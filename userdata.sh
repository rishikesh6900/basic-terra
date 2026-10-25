#!/bin/bash

# Update the package list and install Nginx
apt update -y
apt install nginx -y

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Create portfolio content
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Rishikesh Nate| Portfolio</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      text-align: center;
      padding: 50px;
    }
    h1 {
      color: #333;
    }
    p {
      font-size: 18px;
      color: #666;
    }
    a {
      color: #007BFF;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <h1>Hi, I'm Rishikesh Nate</h1>
  <p>DevOps · CLoud . Gaming XD</p>
  <p>
    <a href="https://blog.rishikesh-nate/.com" target="_blank">Blog</a> |
    <a href="https://x.com/rishikesh-nate/" target="_blank">Twitter</a> |
    <a href="https://www.youtube.com/@rishikesh-nate/" target="_blank">YouTube</a> |
    <a href="https://www.linkedin.com/in/rishikesh-nate/" target="_blank">LinkedIn</a>
  </p>
</body>
</html>
EOF

