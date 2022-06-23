Original App Design Project - README Template
===

# APP_NAME_HERE

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Pickup app, groups can post a synopsis about who they are, what sport, where, when, intensity, a short bio then the app has search capabilities to filter into groups that fit someone’s preferences (possibly display locations on a map?) (Possibly a DM capability)

### App Evaluation
[Evaluation of your app across the following attributes]
- **Mobile:**
This app could have a DM feature and also by making it portable you don't need to have access to your computer for things like travel etc
- **Story:**
This app has a lot of value becuase not only will it promote being active and excersie but it could be a great tool for meeting new people and making friends
- **Market:**
This app wouldn't have an overly large user base but since there is no centralized version of this to the people who do pick up sports this would be a huge benefit. To the individual it gives them access to finding groups and for groups it gives them a tool to find new people
- **Habit:**
This app wouldn't be overly habit forming, it likely wouldn't be heavily used because it only promotes use until someone finds groups they like
- **Scope:**
This App should be reasonable to complete by the end of the designated time, the two hard parts would be implementing a filter option and DM option. If I have time I can also create a map representation of group locations or create a calendar/notifications fofr things.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Groups can post essential info (bio, intensity, sport, location, time)
* App fill filter groups on selected attributes
* DM feature
* Log in/logout

**Optional Nice-to-have Stories**

* Map display of locations of groups
* Favoriting or saving groups
* Calendar view of times groups play
* Notifications for wither DMS or if a group is starting soon

### 2. Screen Archetypes

* Login screen
    * User can login
* Registration screen
    * User can create account
* Search Page
    * User selects certain filters for what they are searching
* Feed
    * User can scroll through list of groups that fit their filters
* Details page
    * Has more indepth description about the group
* Page for posting a group
    * Allows for posting details of a new group
* Page for displaying different DMS
    * Displays similar to different social media apps for most recent DMs
* Individual DMs
    * Shows chat between users

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* login button (login -> search)
* Search button (search -> feed)
* register (login -> register, register -> search)
* Back button (details -> feed, DM display -> feed, DMs -> DM display)
* DM button (feed -> DM display)
* Post button (feed -> create post, create post -> feed)
* Search bar (feed -> search)

**Flow Navigation** (Screen to Screen)

* Feed
   * Details (for specific group)
* DM
   * Go to specific DM after clicking a conversation

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]