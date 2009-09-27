# Constructa

## ALPHA

This is in *Alpha* stages. I don't expect it to work 100% and neither should you (although, that is the ideal situation). If you do try it out and encounter something strange and/or unusual file an issue.

## Styling

For now, I'm using Integrity's styling because it's pretty. Yes, I plan on doing my own later on. 

## Description

Constructa is (yet another) Continuous Integration server. 

It was created out of my disliking of Integrity, which hangs when it's building builds and also does not report accurately about what errors occurred during the setup process of the build. I was not about to go digging in someone else's *Sinatra* source.

## How it works

Set up constructa on your server like a normal Rails application and set up either a Service Hook for a Github repository or a notification for Codebase and point it at either /github or /codebase respectively. Then the next time you push to your repository it will queue up a build to be ran.

Builds are ran by running the `rake jobs:work` command, which uses delayed_job to run the jobs in the background, which means the app itself won't hang unlike other *cough*Integrity*cough* alternatives out there.

## Contributions

Some of the html is ripped from Integrity since I used that to style how the app "flowed" when first crafting it.

