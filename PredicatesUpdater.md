# Introduction #

A major goal of this project is to personalize the conversation the user has with the bot. To do this, public and private facebook data are gathered from the user facebook profile using a Java application based on the [RestFB API](http://www.restfb.com). The predicates the Alicebot uses are then updated with values gathered from the profile.

# Updating the predicates #

To update the predicates, provide a valid access token in the _token.txt_ file and run the UpdatePredicates executable. An access token can be generated through the [facebook api explorer](http://developers.facebook.com/tools/explorer). Since the Alicebot relies on the predicates during the conversation, it is recommended to always update the predicates before launching the bot.

# Details #

This section describes the workings of the updater in more detail.

## Facebook Access ##
For the bot to have access to the data on Facebook, it will need a personal access token from a user.

### Gaining Access ###

As of right now, the application runs entirely offline and has to be provided with an access token before runtime.

An access token can be provided by getting a token string from the [facebook api explorer](http://developers.facebook.com/tools/explorer) and pasting it directly into the token.txt file.

This is obviously placeholder functionality and should be updated to a full facebook login procedure ASAP.

### Permissions ###
When generating the token, please take care to provide enough permissions for the program to function properly. The required permissions are:

  * email
  * user\_relationships
  * user\_events
  * user\_hometown
  * user\_religion\_politics
  * user\_about\_me
  * user\_birthday
  * user\_relationship\_details
  * friends\_relationship\_details
  * firends\_relationships
  * friends\_events
  * read\_mailbox

## The Updater ##

When a valid access token has been provided, the updater UpdatePredicates.exe can be run. This program essentially does three things:

  1. Read the default predicates from a template
  1. Get personalized predicates from Facebook
  1. Write them into the predicates file used by the bot

This functionality is implemented in Java and has been wrapped as an .exe file for convenience. Preset values used by the program are defined in the _config.properties_ file, which is the standard format for a configurations file in Java.

### Startup ###
During startup, the access token is read from the token.txt file and a connection to Facebook is established. The properties file is also loaded.

### Reading ###
At this point, the program reads the default predicates from a template. By default, this is the _PredicatesTemplate.txt_ file. This file contains key-value(KV) pairs that are loaded into a Map<String,String>. The default implementation uses a HashMap.

More predicates can be added manually to the template file. Make sure, however, that the file does not contain empty lines between the KV-pairs, since this will cause errors with the program.

### Getting FB Data ###
Now that the predicates are read, it is time to update them. For preset keys, the values are updated by making a query through the [RestFB API](http://www.restfb.com). The predicates that are updated by default are:

| **Key** | **Description** |
|:--------|:----------------|
| age     | The current age of the user |
| birthday | The birthday of the user (dd-MM-yyyy) |
| name    | The full name of the user |
|firstname | The first name of the user |
| lastname | The lastname of the user |
| gender  | The user's gender (male/female) |
| city    | The user's hometown |
| party   | The user's political preference |
| religion | The user's religion |
| email   | The email of the user |
| relationshipstatus | A description of the user's current relationship status |
| education | A list of the user's educational background |
| employer | A list of all current and previous employers |
| sport   | A list of the user's preferred sports |
| girlfriend | The full name of the user's girlfriend |
| boyfriend | The full name of the user's boyfriend |
| facebookfriends | The amount of friends the user has on Facebook |
| brother | The name of the user's brother |
| friend  | A sorted list of the user's favourite friends, based on the amount of messages in the last week |

All list entries are listed as **key**_1..n_**:**value in the predicates file.

By far the most intensive calculation is determining the user's favourite friends by using the amount of messages that have been sent in the facebook chat over the last week. However, it is included as it is deemed useful information for the bot to know and is used frequently in conversations.

It is important to note that predicates that cannot be updated with useful facebook data (i.e. _null_ values that are returned if the user does not have certain information available on their profiles) will not be overwritten.

### Writing ###
Finally, the now updated predicates are written to the predicates.txt file used by the bot. Alice can now use this information in it's conversations.

Due to the usage of a HashMap, the KV-pairs are not written in the same order as they were read. This does not have any consequences for the bot, it just makes them harder to read for us people.

# Work in Progress #
The biggest fault with the current implementation is that it is currently very cumbersome to provide the application with an access token. This procedure should be replaced with a proper facebook-login process ASAP.

In addition, more facebook predicates are always useful and implementing them will be a continuous process.