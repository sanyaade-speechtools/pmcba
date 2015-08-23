## Introduction ##
The (personal moral chat bot api) is a toolbox for creating socially aware chat bots. It consist out of three different components. These three different components full fill a different roll within the workflow.

The main components are:
  1. Facebook-context to AIML-properties converter
  1. AIML conversations generator
  1. A slightly modified version of the "super chat bot"

### idea/motivation ###

The Beginning:
The origin for this project was to create a chat bot that is aware of ones social background and is capable of talking with you about that background. The goal was to help people to reflect on their own behavior. It can be understood as an enhanced version of the ELIZA http://en.wikipedia.org/wiki/ELIZA bot.

The project now:
Based on the original goal the project was developed. In order to be able to handle the required conversations and context informations it was necessary for us to build a set of tools. These tools then became the foundation of this project.
The Idea now is that people can use this tool to create their own moral chat bot. That allows interaction about the context information of a client.




### WorkFlowConcept ###

This part describes the basic workflow as thought out for this project. It is one possible approach for using these tools.

1.CREATE
In a first step the processing program can be used to create conversations for the ChatBot. Within this program one is able to incorporate the Facebook data, define answers to questions and define answer reduction options.

2.INCOPERATE
Most likely it is not enough to only use the conversation that where created in the conversation editor to achieve a natural feeling for a conversation. Therefore the created conversations (AIML files) should be incorporate with an existing chat bot. We adapted a version of the SUPERBOT (https://code.google.com/p/aiml-en-us-foundation-super/). The new AIML files should be incorporate within the AIML folder.

3.APPLY
Download or use an online AIML interpreter. These programs convert the AIML files into a bot the can have conversations with a user. Check AIML Interpreter page for more info. For this project we used the program-ab. To be found here(https://code.google.com/p/program-ab/)


## Components in detail ##

### FacebookToAIMLPredicates ###

The main task of this program is to convert and analyze data that is available from Facebook of a certain user. The available data get converted into predicates that can be used within the conversations.

This program is written in java and uses the restfb java library to fetch the data.(http://restfb.com/)

### AIMLConversationGenerator ###

This program allows the user to create conversational trees that are then converted into AIML files. The here created AIML files can then put into the bots AIML directory and will be loaded the next time the bot load the files.

### Altered SUPERBOT ###
Included into the repository are files from the SUPER chat bot 0.0.4/0.0.3 (to be found here: https://code.google.com/p/aiml-en-us-foundation-super/)
The bot was altered to not use the internet nor try to call any '<'oob'>' system/phone commands.

## TODO ##
  * get:  the Facebook Application certified So its usable by everyone.
  * add: Automatically suggest reduction options based on the answer in the conversation.