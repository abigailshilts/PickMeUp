Original App Design Project - README Template
===

# PickMeUp

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Pickup app, groups can post a synopsis about who they are, what sport, where, when, intensity, a short bio then the app has search capabilities to filter into groups that fit someone’s preferences, and can display search results as pins on map. Additionally users can start conversations and DM groups for more information, save posts that they like, and create events that will appear at the top of any search within a 15 mile radious for the span of a day.

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
* App will filter groups on selected attributes
* Be able to see a details veiw about groups
* Log in/logout

**Optional Nice-to-have Stories**

* DM feature
* Map display of locations of groups
* Favoriting or saving groups
* Calendar view of times groups play

### 2. Screen Archetypes

* Login screen
    * User can login
* Registration screen
    * User can create account
* Search Page
    * User selects certain filters for what they are searching
* Feed
    * User can scroll through list of groups that fit their filters
* Map
   *  Users can view the results of their search as pins on a map
* Details page
    * Has more indepth description about the group
* Page displaying your own posts
    * Shows a feed of only posts the current user has created
* Page for posting a group
    * Allows for posting details of a new group
* Page for displaying different DMS
    * Displays similar to different social media apps for current conversations
* Individual DMs
    * Shows chat between users
* Events DM
    * Displays DMs of all people with access to the post in a groupchat or forum like way
* Make event
   *  Allows user to make an event
*  Saved posts
   * Displays all posts a user has saved 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Search tab -> search screen
* My posts tab -> my posts screen
* DMs tab -> screen displaying converations

**Flow Navigation** (Screen to Screen)

* login button (login -> search, login -> register)
* register (register -> search)
* Search (search -> feed)
* Feed/Search results (feed -> map, feed -> details view)
* Details view (Details -> DM display)
* Conversations (conversations screen -> DM display)
* Your posts (your posts -> make a post, your posts -> make an event, your posts -> saved posts)

## Wireframes
Original:
![289042721_709221586803849_9052767981505465934_n](https://user-images.githubusercontent.com/58635711/182743208-a8db9193-f662-43a6-b619-3b1f826869b0.jpg)

Current:
![297174470_1407562166395336_229920820450356999_n](https://user-images.githubusercontent.com/58635711/182908808-b593878e-a57e-41db-b066-f8f73ae0901f.jpg)

## Schema 
[This section will be completed in Unit 9]
### Models
User
* User id
* Username
* Password
* email
* Array of saved posts
Post
* Img
* Description
* Intensity
* Sport
* Location
* When
* IsEvent
Conversation
* Sender
* Receiver
DM
* Convo Id
* Content
* Sender

### Networking
- Login screen: Does a log in request
- Sign up: does a post request to create a new user
- Search screen: get request based on inputed search paramaters
- Details view: get request for conversation related to post
- My Posts: get request for current user posts
- Make Posts: post request to make new post object
- Make Events: post request to make new event object
- Conversations: get request for all current conversations
- DMs: Get request for all current DMs and live query for new ones, post requests for new conversations and DMs
