#codigo microsoft adaptado
from dotenv import load_dotenv
import os
import time
from PIL import Image, ImageDraw
from matplotlib import pyplot as plt
import sys

# import namespaces
from azure.ai.vision.imageanalysis import ImageAnalysisClient
from azure.ai.vision.imageanalysis.models import VisualFeatures
from azure.core.credentials import AzureKeyCredential

def main():

    global cv_client

    try:
        # Get Configuration Settings
        load_dotenv()
        ai_endpoint = os.getenv('AI_SERVICE_ENDPOINT')
        ai_key = os.getenv('AI_SERVICE_KEY')

        # Authenticate Azure AI Vision client 
        cv_client = ImageAnalysisClient(
        endpoint=ai_endpoint,
        credential=AzureKeyCredential(ai_key)
 )

        image_file = os.path.join(sys.argv[1])
        GetTextRead(image_file)
                

    except Exception as ex:
        print(ex)

def GetTextRead(image_file):

    # Open image file
    with open(image_file, "rb") as f:
            image_data = f.read()

    result = cv_client.analyze(
    image_data=image_data,
    visual_features=[VisualFeatures.READ]
    )

 # Display the image and overlay it with the extracted text
    for line in result.read.blocks[0].lines:
        text = line.text
        print(f"  {text}")   


if __name__ == "__main__":
    main()
