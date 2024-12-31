# Automated-Glove-Defect-Detection-System-Using-Image-Processing
Using image processing and computer vision in MATLAB to develop a defect detection system for medical and industrial gloves. It identifies defects like stains, tears, missing fingers, and stitching issues across materials such as latex, silicone, cloth, and rubber nitrile.


---
  - <img width="500" alt="Screenshot 2024-12-31 at 11 56 57 AM" src="https://github.com/user-attachments/assets/4dfa0e95-b06c-4764-ba01-b6fa43af1514" />

1. **Defect Detection Techniques**:
   - **Color-Based Segmentation**: Used for identifying regions with stains or discolorations.
   - **Thresholding and Blurring**: For precise defect localization and image smoothing.
     
     <img width="500" alt="Screenshot 2024-12-31 at 12 00 12 PM" src="https://github.com/user-attachments/assets/7d07bd01-6966-4c34-a298-7b0b1c825c61" />
     
   - **Morphological Operations**: Erosion and dilation enhance defect shapes for accurate detection.
   - **Connected Component and Region Properties Analysis**: Isolates defects for classification and quantification.
     
     <img width="500" alt="Screenshot 2024-12-31 at 12 03 29 PM" src="https://github.com/user-attachments/assets/3abbd724-059f-4c61-9678-4bb4ca92697b" />
  
     <img width="500" alt="Screenshot 2024-12-31 at 12 03 46 PM" src="https://github.com/user-attachments/assets/f72f9ea2-e0e0-4f19-8bb4-9d1b671cc1b3" />
     
     <img width="500" alt="Screenshot 2024-12-31 at 12 20 47 PM" src="https://github.com/user-attachments/assets/f0b7c637-f1b9-4873-a3d6-0210e89040d3" />
---
     
2. **Types of Gloves the System Can Detect**:
  - **Latex Gloves**
  - **Silicone Gloves**
  - **Cloth Gloves**
  - **Rubber Nitrile Gloves**

---
    
3. **Types of Defects the System Can Detect:**
  - **Stains**
  - **Dirty Areas**
  - **Mold**
  - **Stitching Irregularities**
  - **Holes**
  - **Tears**
  - **Missing Fingers**

   
     

4. **Graphical User Interface (GUI)**:
   - Allows users to upload glove images, visualize defect detection results, and interact with the system seamlessly.
---
5. **Performance**:
   - Robust against changes in lighting, glove position, and defect severity.
   - High accuracy for most defect types, with room for optimization to reduce false positives and negatives.
     <img width="500" alt="Screenshot 2024-12-31 at 12 19 06 PM" src="https://github.com/user-attachments/assets/6a877420-761d-426c-8943-df01c843b37d" />
     <img width="500" alt="Screenshot 2024-12-31 at 12 22 41 PM" src="https://github.com/user-attachments/assets/c6e699c1-428e-4aac-877d-9bb86b91b6ea" />
     <img width="500" alt="Screenshot 2024-12-31 at 12 24 11 PM" src="https://github.com/user-attachments/assets/be8cb5dd-cbe9-47af-938a-f0cea7f1f625" />
     <img width="500" alt="Screenshot 2024-12-31 at 12 23 36 PM" src="https://github.com/user-attachments/assets/eb3f066f-d9aa-4d70-b40a-5dc48705c88f" />
     <img width="500" alt="Screenshot 2024-12-31 at 12 24 02 PM" src="https://github.com/user-attachments/assets/064762d8-585f-4e99-85df-752f4da4fe4a" />
     <img width="500" alt="Screenshot 2024-12-31 at 12 24 24 PM" src="https://github.com/user-attachments/assets/60d846d9-34b9-47a2-b6c3-dadd3e2d02dd" />



  
   

---

#### Results and Insights
- **Algorithms**: Effectively detect and segment defects across glove types using tailored image processing methods.
- **Challenges**: Differentiating subtle defects and addressing computational efficiency for high-speed production environments.
- **Future Directions**:
   - Enhance preprocessing techniques to handle lighting variations and complex backgrounds.
   - Implement advanced segmentation algorithms for better defect localization.
   - Integrate adaptive algorithms to improve robustness and scalability.


