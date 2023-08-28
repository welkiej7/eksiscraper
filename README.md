# Eksi Sözlük Scraper



![Ekşi_Sözlük_ikon svg](https://github.com/welkiej7/eksiscraper/assets/94485797/5626c533-2150-4c98-b63c-5d29829b477d)

The main idea behind this project is to retrieve eksi sözlük data as automated and fast as possible.  It includes 3 fundamental functions and one script for automation, all written in R. There is no eksisözlük API open to use, therefore the code is an html scraper. 


## GET SOL FRAME

A function that returns the values in the sol frame (left frame, but this is how it is called in the forum) as a data frame. Two unique columns, Topic and Identifier, return. Topic is the topic id, and the identifier is the unique identifier of that topic. Probably the identifier used in the eksisözlük database. 


## GET TOPIC

Retrieve all, or certain entries listed under a topic. If leftover is false, the function will return all topics and number of pages as a list, if leftover is true, requires a leftover no (leftover page number) to retrieve the entries after that page. 

NOTE: If you have an eksisozluk account, remember to signoff before using the tool. Pages are listed with 10 entries. 


## SET ENV

This function requires the necessary libraries and connects the database of the downloaded files. 


## SCRIPT

Complete automation to retrieve data with sol frames. Checks if the topic exists in the database, if it does, then just updates the topic and schema.


## Additional Notes

- Schema, is basically an csv object that gives information about the database. 
- Database is just a folder that contains downloaded files. 


-Currently segfault memory error can appear while running with macOS Ventura 13.4. To understand the error, i am running it with garbage collector info. Therefore script_gc is the garbage collector info version of the same script given in script.R





Please contact me for suggestions. 
