import os
import time
import json
import numpy as np
import cv2
import torch
import lpips
from skimage.metrics import peak_signal_noise_ratio as psnr
from skimage.metrics import structural_similarity as ssim
import argparse

# LPIPS model (requires GPU if available)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print("Using device:", device)
lpips_model = lpips.LPIPS(net='alex').to(device)

def compute_metrics(gt_img, rendered_img):
    """Computes PSNR, SSIM, and LPIPS between ground truth and rendered images."""
    gt = cv2.imread(gt_img)
    rend = cv2.imread(rendered_img)
    
    gt = cv2.resize(gt, (rend.shape[1], rend.shape[0]))  # Ensure matching dimensions
    gt_gray = cv2.cvtColor(gt, cv2.COLOR_BGR2GRAY)
    rend_gray = cv2.cvtColor(rend, cv2.COLOR_BGR2GRAY)
    
    psnr_value = psnr(gt_gray, rend_gray, data_range=255)
    ssim_value = ssim(gt_gray, rend_gray, data_range=255)
    
    gt_tensor = torch.tensor(gt).permute(2, 0, 1).float().unsqueeze(0).to(device) / 255.0
    rend_tensor = torch.tensor(rend).permute(2, 0, 1).float().unsqueeze(0).to(device) / 255.0
    
    lpips_value = lpips_model(gt_tensor, rend_tensor).item()
    
    return psnr_value, ssim_value, lpips_value

def evaluate_training(renders_path, gt_path, output_report):
    """Evaluates training performance by analyzing logs and computing quality metrics."""
    results = {}
    
    quality_metrics = {}
    psnr_values, ssim_values, lpips_values = [], [], []

    for filename in os.listdir(renders_path):
        if filename.endswith(".png"):
            gt_img = os.path.join(gt_path, filename)
            rendered_img = os.path.join(renders_path, filename)
            if os.path.exists(gt_img):
                psnr_v, ssim_v, lpips_v = compute_metrics(gt_img, rendered_img)
                quality_metrics[filename] = {"PSNR": psnr_v, "SSIM": ssim_v, "LPIPS": lpips_v}
                psnr_values.append(psnr_v)
                ssim_values.append(ssim_v)
                lpips_values.append(lpips_v)
    
    results['quality_metrics'] = quality_metrics
    results['average_metrics'] = {
        "PSNR": np.mean(psnr_values),
        "SSIM": np.mean(ssim_values),
        "LPIPS": np.mean(lpips_values)
    }
    
    with open(output_report, 'w') as f:
        json.dump(results, f, indent=4)
    
    print("Evaluation complete. Results saved to", output_report)

def main():
    parser = argparse.ArgumentParser(description="Get evaluation metrics for rendered images.")
    parser.add_argument("input", help="Path to directory container directories of ground truth and rendered images.")
    args = parser.parse_args()
    if args.input and os.path.exists(args.input):
        renders_path = os.path.join(args.input, "renders")
        gt_path = os.path.join(args.input, "gt")
        out_path = os.path.join(args.input, "test_results.json")
    else:
        print("Invalid input path. Exiting.")
        exit(1)

    start_time = time.time()
    evaluate_training(renders_path, gt_path, out_path)
    print(f"Test completed in {time.time() - start_time:.2f} seconds.")

if __name__ == "__main__":
    main()
