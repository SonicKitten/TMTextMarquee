This class is a text label that can scroll if the text doesn't fix the width of the label. It will only start scrolling when the scroll method is called. you can use an NSTimer to get it scrolling periodically. I built it this way so I could have a set of TMTextMarqees that scroll one at a time.  

Set text with the setText method. Set the font by setting the font property. You can set the speed property to change the speed of the scroll, in pixels-per-second. You can set the font with the font property.

This class allows you to assign a delegate. The only thing the delegate does is tell you when a label has stopped scrolling.
