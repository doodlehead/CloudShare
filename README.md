# README
Authors: Frank Yu and William Lu
Date: September 2016-Janurary 2017

CloudShare is a file storage and file sharing website. It was made for our school's computer science class.

This was our first rails project. We used Michael Hartl https://www.railstutorial.org as our preliminary tutorial. Check 
him out!

To access our app, go to: https://cloudshare-project.herokuapp.com

Note that heroku will delete the files stored by users every day. However, they will still show up in file index–but if you try to access(download) it, rails will through an error. To fix this, simply delete the file. In the future, Amazon S3 will be used to permanently store the files, fixing this issue. Sorry for the inconvenience. 

However, if you run the app on your own server (eg. localhost) the files will remain.
