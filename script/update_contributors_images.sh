#!/bin/bash

escapedHtmlList='\n <a href="https://github.com/maboloshi" title="沙漠之子">\n <img src="https://avatars.githubusercontent.com/u/7850715?v=4" width="42;" alt="沙漠之子"/>\n </a>'
startMarker="<!--AUTO_GENERATED_PLEASE_DONT_DELETE_IT-->"
endMarker="<!--AUTO_GENERATED_PLEASE_DONT_DELETE_IT-END-->"

sed '/'"$startMarker"'/,/'"$endMarker"'/c\'"$startMarker$escapedHtmlList$endMarker" README.md > temp.md
