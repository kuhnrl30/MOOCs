# MOOC Dropout Rates
This analysis was performed to compete in the 2015 KDD Cup. 
The objective was to predict whether a given learner would 
drop out of a MOOC in the next 10 days given a set of activities 
such as lectures viewed and assignements completed.  There were 
datasets Objects, Dates, Training.  

### Objects  
Variable | Description  
| ----  | ----  
course id | Parent course  
module id | Unique ID assigned to each module  
category | Category of module such as Chapter, problem, sequential, vertical, video, discussion  
children | Children modules  
start | Date the module became available to the leaner.  

### Dates  
Variable | Description   
| ---- | ----  
course id | Unique course id number  
from | Course start date  
to | Course end date  

### Enrollment  
Variable | Description  
---- | ----  
enrollment id | unique identifier for enrollement.  
username | Unique ID for each learner.  
course id | Course the learner enrolled in.  

### Log
Variable | Description  
---- | ----  
enrollment id | Enrollement ID corresponding to the Enrollment table.  
time | Time the event occured  
source | Server or Browser  
event | The event the learner took.  Examples include navigating to the object, completing a problem, or accessing a site  
object | Object ID corresponding to the the unique identifier in the Object table  