import boto3, os, datetime

BUCKET = "cloud-secure-infra-dev-image-metadata"
CRAWLER = "cloud-secure-infra-dev-compliance-crawler"
REGION = "ap-south-1"
REPORTS_PATH = "./reports"

s3 = boto3.client("s3", region_name=REGION)
glue = boto3.client("glue", region_name=REGION)

timestamp = datetime.datetime.now(datetime.UTC).strftime("%Y%m%d%H%M%S")

for root, _, files in os.walk(REPORTS_PATH):
    for f in files:
        if f.endswith(".json"):
            file_path = os.path.join(root, f)
            key = f"reports/raw/os/{f.split('.')[0]}-{timestamp}.json"
            print(f"📤 Uploading {file_path} to s3://{BUCKET}/{key}")
            s3.upload_file(file_path, BUCKET, key)

print(f"🚀 Triggering Glue Crawler: {CRAWLER}")
glue.start_crawler(Name=CRAWLER)
