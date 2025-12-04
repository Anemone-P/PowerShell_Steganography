The Encoder.ps1 takes an existing PNG and allows you to embed text directly into the photo by changing the Alpha values of pixels. This method only works properly on an entirely 255 Alpha image. PNG's with empty backgrounds will have every pixel changed to an Alpha value of 255 before encoding. The encoding takes a text string and converts it into Hex, and then uses an offset array (+1) to assign a numeric value to each individual hex character. If a Hex value of "3" was going to be encoded into a pixel, it would set the Alpha value of that pixel to 251. 255 - 4 = 251. This allows for finding the edited pixels by looking for any pixel where the Alpha is set to less than 255. 255 = unchanged and 254 = 0.

The pixels get changed starting from the top left pixel 0,0 and run down the first column until 0,200. The then start encoding again at 1,0. On a full white image the effect is easier to spot, but on any standard photo it isnt particularly visible unless you are already looking for it. The lowest possible alpha applied to a pixel can only be 238 or -17.

Usage example:
<img width="1123" height="52" alt="image" src="https://github.com/user-attachments/assets/3c655a0d-85ff-4793-be84-093b4b01c574" />
<img width="1014" height="62" alt="image" src="https://github.com/user-attachments/assets/4895a39a-de26-4559-a6ac-1ce510045fb9" />



Output's a new image in the same directory with a similar name
GaryMakingCoffee.png -> GaryMakingCoffee_2.png

Original:

<img width="479" height="643" alt="GaryMakingCoffee" src="https://github.com/user-attachments/assets/f3245eec-a4ad-4aa3-98f2-dcbca8d7dd3c" />



With text encoded:

<img width="479" height="643" alt="GaryMakingCoffee_2" src="https://github.com/user-attachments/assets/01360cc9-7566-4c2f-a663-076ddabc9e5d" />



