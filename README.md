# Download Log Analyzer
## Functionality:-

This log analyzer will analyze the downloads by all types of users in narmada/nis server in IIIT Jabalpur and take necessary actions in their user directory.This tool can be used to delete the unnecessary items like video files in case of memory shortage. 

This utility can be used for monitoring the space usage and moderating the content.

## Flow of actions:-

1. Ask the administrator to enter into a particular directory like faculty ,lab ,staff & student.
2. Perform action on faculty ,lab & staff such as
    1. Categorized downloads by type(movies,music,documents etc).
    2. List the downloads with date of last modification.
    3. Delete the files greater than size provided by administrator.
3. Perform action on student especially on individual , whole group , particular batch or particular branch .
    1. Total space taken by a group ,batch or branch.
    2. Delete the files greater than size provided by administrator.
4. Perform action on known ID/Roll No of any student ,staff ,faculty or lab instructor and directory structure is fetched from passwd.txt.
    1. Categorized downloads by type(movies,music,documents etc).
    2. List the downloads with date of last modification.
    3. Delete the files greater than size provided by administrator.
5. All deleted downloads are stored in delete.log with structure

            ID/Roll No:File Name:Size Of file:Time of delete

#### Authors: Shivam Sharma ,Rishabh Gupta & Abhinav Gupta