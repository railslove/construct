# Constructa

## Beta 
This is in *Beta* stages. I don't expect it to work 100% and neither should you (although, that is the ideal situation). If you do try it out and encounter something strange and/or unusual file an issue.

## Setup

Download the app set it up (I've done it using passenger) and point your Github/Codebase project's post-receive hooks at it, keeping in mind the github post-receive hook is http://ci.yourcompany.com/github and Codebase's is http://ci.yourcompany.com/codebase.

Before you push however you should create a _/data/builds_ directory and the user that is running the application should have write access to this folder as that's where builds go. If you don't want them to go there, put them in another folder (*but NOT in a folder inside the app itself, as that has lead to holes in Time & Space, amongst other things!*)

You'll also need to be running the `rake jobs:work` jobs runner. I run mine in a screen, although I will be adding in later a God config for this. The benefit of running a background task like this is that it _will not lock up your application whilst your tests are running_. It also provides a *live output* feed so you can see precisely where your build is up to.

Finally, you can push to your repositories and with any luck they'll build successfully on construct and you'll see beautiful green instead of fear-inspiring red. Good luck!

## Description

Constructa is (yet another) Continuous Integration server. 

It was created out of my disliking of Integrity, which hangs when it's building builds and also does not report accurately about what errors occurred during the setup process of the build. I was not about to go digging in someone else's *Sinatra* source.

## Contributions

Integrity (and by extension, foca) - Inspiring this whole project.

Bodaniel Jeanes - Giving me a place to hack this out on Spring Tuesday Night.

Dr Nic Williams - For encouraging me and giving time to work on it whilst at work.

