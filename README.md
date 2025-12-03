The Encoder.ps1 takes an existing PNG and allows you to embed text directly into the photo by changing the Alpha values of pixels. This method only works properly on an entirely 255 Alpha image. PNG's with empty backgrounds will have every pixel changed to an Alpha value of 255 before encoding. The encoding takes a text string and converts it into Hex, and then uses an offset array (+1) to assign a numeric value to each individual hex character. If a Hex value of "3" was going to be encoded into a pixel, it would set the Alpha value of that pixel to 251. 255 - 4 = 251. This allows for finding the edited pixels by looking for any pixel where the Alpha is set to less than 255. 255 = unchanged and 254 = 0.

The pixels get changed starting from the top left pixel 0,0 and run down the first column until 0,200. The then start encoding again at 1,0. On a full white image the effect is easier to spot, but on any standard photo it isnt particularly visible unless you are already looking for it. The lowest possible alpha applied to a pixel can only be 238 or -17.

Usage example:
<img width="1167" height="34" alt="image" src="https://github.com/user-attachments/assets/cf148fc8-3d89-46ec-84ec-b1a899f15b6a" />

Output's a new image in the same directory with a similar name
Gary_Yawn.png -> Gary_Yawn_2.png

Original:



With text encoded:



