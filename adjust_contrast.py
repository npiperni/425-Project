import os
import cv2
import argparse

def adjust_contrast(image, alpha):
    """Applies contrast adjustment to an image."""
    return cv2.convertScaleAbs(image, alpha=alpha, beta=0)

def process_images(input_dir, output_dir):
    """Processes all images in the input directory and saves them with high and low contrast."""
    # Define output folders
    high_contrast_dir = os.path.join(output_dir, "high_contrast")
    low_contrast_dir = os.path.join(output_dir, "low_contrast")

    # Create directories if they don't exist
    os.makedirs(high_contrast_dir, exist_ok=True)
    os.makedirs(low_contrast_dir, exist_ok=True)

    # Process all images
    for filename in os.listdir(input_dir):
        if filename.lower().endswith((".png", ".jpg", ".jpeg")):
            image_path = os.path.join(input_dir, filename)
            image = cv2.imread(image_path)

            if image is None:
                print(f"Skipping {filename} (could not load image)")
                continue

            # Apply contrast adjustments
            high_contrast = adjust_contrast(image, alpha=1.5)  # Increase contrast
            low_contrast = adjust_contrast(image, alpha=0.7)   # Decrease contrast

            # Save images
            cv2.imwrite(os.path.join(high_contrast_dir, filename), high_contrast)
            cv2.imwrite(os.path.join(low_contrast_dir, filename), low_contrast)

            print(f"Processed {filename}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Apply high and low contrast filters to images in a directory.")
    parser.add_argument("--input_path", type=str, required=True, help="Path to input directory containing images.")
    parser.add_argument("--output_path", type=str, required=True, help="Path to output directory where processed images will be saved.")

    args = parser.parse_args()

    if not os.path.exists(args.input_path):
        print("Error: Input directory does not exist.")
        exit(1)

    process_images(args.input_path, args.output_path)
    print("Contrast adjustment complete.")
