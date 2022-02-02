![919 NUI Speedlimit Resource|690x388](https://i.imgur.com/eyUi3ED.png)

# 919-speedlimits
Here is a quick resource I made for my racing server after seeing some speed limit display resources that were made using DrawText in a loop. I wanted to get a much more visually pleasing implementation while also making it more performant.</div>

Preview: https://www.youtube.com/watch?v=fCIJyM50x-A

## Installation
Drag and drop the resource into your server resources folder. Start the resource or ensure it in server.cfg.

## USAGE:
Client Event: 919-speedlimit:client:ToggleSpeedLimit

Arguments: None

Trigger this client event to toggle the speed limit display on or off. It will only show while in a vehicle.
```
TriggerEvent('919-speedlimit:client:ToggleSpeedLimit')
```

## FAQ:
1. **Q:** How do I change the size of the speed limit sign on screen?

**A:** In the file "html/index.html", change the "max-width" value to your desired value. Default: 100px. A size of half the default would look as follows:
```
        #speedlimit > img {
          max-width: 50px;
        }
```
2. **Q:** How do I change the position of the speed limit sign on screen?

**A:** In the file "html/index.html", change the "right" and "bottom" values to match your desired position. For example, a position above the minimap on the left would look as follows:
```
        #speedlimit {
            display:none;
            position:absolute;
            left:2vw;
            bottom:15vh;
        }
```
