#Name is misleading. This stores the helper methods for everything related to encryption
module KeysHelper
  require 'openssl'
  include SessionsHelper
  
  def create_keypair(password)
    key = OpenSSL::PKey::RSA.new 2048
   
    cipher = OpenSSL::Cipher.new 'AES-128-CBC'
    pass_phrase = password
    
    private_secure = key.export cipher, pass_phrase
    
    return {eprivate_key: private_secure, public_key: key.public_key}
  end
  
  def symmetric_encrypt(file)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    dkey = cipher.random_key
    iv = cipher.random_iv
    
    pubKey = OpenSSL::PKey::RSA.new current_user.public_key
    encKey = key_encrypt(dkey,pubKey) 
    
    user_id = current_user.id
    keyHash = {owner_id: user_id, iv: iv, ekey: encKey}
    buf = ''
        
    encFile = Tempfile.new("tempEncrypted")
    #Opened in binary mode to avoid encoding conversion errors
    File.open(encFile,"wb") do |outf|
      File.open(file.asset.path,"rb") do |inf|
        while inf.read(4096,buf)
          outf << cipher.update(buf)
        end
        outf << cipher.final
      end
    end
        
    File.open(encFile, "rb") do |input|
      File.open(file.asset.path, "wb") do |output|
        while buff = input.read(4096)
          output.write(buff)
        end
      end
    end   
        
    encFile.unlink    
    return keyHash
  end
  
  def symmetric_decrypt(eFile,password)
    @key = Key.find_by(owner_id: current_user.id, asset_id: eFile.id)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt
    eKey = @key.ekey
    iv = @key.iv 
    
    dKey = key_decrypt(eKey,password)
    decFile = Tempfile.new("tempDecrypted")
        
    cipher.key = dKey
    cipher.iv = iv
    buf = ''
    
    File.open(decFile,"wb") do |outf|
      File.open(eFile.asset.path,"rb") do |inf|
        while inf.read(4096,buf)
          outf << cipher.update(buf)
        end
        outf << cipher.final
      end
    end
    
    tempAsset = Asset.new(user_id: current_user.id, tempfile: true)
    tempAsset.asset = decFile
    tempAsset.save!
    
    decFile.unlink
    
    return tempAsset
  end
  
  def key_encrypt(dKey,pubKey)
    eKey = pubKey.public_encrypt dKey
    return eKey
  end

  def key_decrypt(eKey,password)
    privKey = OpenSSL::PKey::RSA.new current_user.eprivate_key, password
    dKey = privKey.private_decrypt eKey
    return dKey
  end
  
  def share_key(other_user_id, file, password)
    eKey = Key.find_by(owner_id: current_user.id, asset_id: file.id).ekey
    dKey = key_decrypt(eKey,password)
    
    other_user = User.find_by_id(other_user_id)
    pubKey = OpenSSL::PKey::RSA.new other_user.public_key
    
    shareKey = key_encrypt(dKey,pubKey)
    
    origKey = Key.find_by(owner_id: current_user.id, asset_id: file.id)
    Key.create(asset_id: file.id, owner_id: other_user_id, iv: origKey.iv, ekey: shareKey)
  end
  
end