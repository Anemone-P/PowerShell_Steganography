The Encoder.ps1 takes an existing image file and allows you to embed text directly into the photo by changing the Alpha values of pixels. This method only works properly on an entirely 255 Alpha image. PNG's with empty backgrounds will have every pixel changed to an Alpha value of 255 before encoding. The encoding takes a text string and converts it into Hex, and then uses an offset array (+1) to assign a numeric value to each individual hex character. If a Hex value of "3" was going to be encoded into a pixel, it would set the Alpha value of that pixel to 251. 255 - 4 = 251. This allows for finding the edited pixels by looking for any pixel where the Alpha is set to less than 255. 255 = unchanged and 254 = 0.

The pixels get changed starting from the top left pixel 0,0 and run down the first column until 0,200. They then start encoding again at 1,0. On a solid color image the effect is easier to spot, but on any standard photo it isnt visible unless the image is extremely low resolution. The lowest possible alpha applied to a pixel can only be 238 or -17.

Usage example:
<img width="1123" height="52" alt="image" src="https://github.com/user-attachments/assets/3c655a0d-85ff-4793-be84-093b4b01c574" />
<img width="1014" height="62" alt="image" src="https://github.com/user-attachments/assets/4895a39a-de26-4559-a6ac-1ce510045fb9" />



Output's a new image in the same directory with a similar name
GaryMakingCoffee.png -> GaryMakingCoffee_2.png

Original:

<img width="1500" height="2000" alt="GaryMakingCoffee" src="https://github.com/user-attachments/assets/d411adf4-8da5-415e-82c1-d10d1e1f7b30" />




With text encoded:

<img width="1500" height="2000" alt="GaryMakingCoffee_2" src="https://github.com/user-attachments/assets/009fc615-1b1b-412e-bc89-9edb88937c30" />



Here is a zoomed in bit of the top left corner where the data is stored for both GaryMakingCoffee and GaryMakingCoffee_2
This image is 1500x2000 and the window screen provides a pattern which makes it much harder to see. 

  Original on the left  <img width="232" height="229" alt="image" src="https://github.com/user-attachments/assets/3e4822dd-7bcf-4af1-88c9-c9f812bf0cdd" />   Encoded text on the right


Below is text encoded on a 100 x 100 image to show how the effect can look:
The text: "This is a ton of example text using many characters so we get a lot of random Alpha valuezzzzz"
I tried to include as many characters as possible to get as much affect as possible.

<img width="100" height="100" alt="SmallTestImage_2" src="https://github.com/user-attachments/assets/43886d11-50c9-4de7-ba22-45e6abd277dd" />


Zoomed into the top left of the image you can slightly see the Alpha pattern in the pixels

<img width="359" height="793" alt="image" src="https://github.com/user-attachments/assets/dcf7a7f5-0afb-482e-b60f-aa4971a2f329" />
