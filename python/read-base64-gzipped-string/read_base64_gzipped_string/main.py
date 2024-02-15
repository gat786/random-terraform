import base64
import gzip
import json

def decode_base64(data):
  return base64.b64decode(data)

def decompress(data):
  return gzip.decompress(data)

def main():
  file_names = ["1.json","2.json"]
  
  for file_name in file_names:
    file_path = (f"read_base64_gzipped_string/data/{file_name}")
    with open(file_path,'r') as read_file:
      json_content = json.loads("\n".join(read_file.readlines()))
      
      if "awslogs" in json_content:
        if "data" in json_content["awslogs"]:
          data = json_content["awslogs"]["data"]
          
          decoded_data_bytes  = decode_base64(data)
          decompressed_data   = decompress(decoded_data_bytes)
          print('decompressed data',decompressed_data)
      
  print("Hello world")
