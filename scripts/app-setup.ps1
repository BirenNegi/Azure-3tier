# Install Python
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.10.0/python.exe" -OutFile "python.exe"
Start-Process python.exe -ArgumentList "/quiet InstallAllUsers=1" -Wait

# Run backend app
pip install flask
python backend.py