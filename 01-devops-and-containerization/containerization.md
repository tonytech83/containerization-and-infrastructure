1.	Run a container named homework based on the image shekeriev/animal-stories
```sh
docker run -it --name homework shekeriev/animal-stories
```
2.	Find the file animal-stories.txt that is inside the container
```sh
find /etc /usr /var -name "animal-stories.txt" 2>/dev/null

/usr/include/animal-stories.txt
```
3.	Explore its contents and find all the rows about tigers
```sh
cat /usr/include/animal-stories.txt | grep tigers

white-tigers-are-good-and-dream-cucumbers
purple-tigers-are-lazy-and-smell-kiwis
brown-tigers-are-clever-and-dream-apples
white-tigers-are-fast-and-like-bananas
brown-tigers-are-bad-and-smell-kiwis
```
4.	Finally, prepare a list of all the unique colors sorted in reverse (descending) order
```sh
awk -F'-' '{print $1}' /usr/include/animal-stories.txt | sort -ur

yellow
white
purple
pink
orange
green
gray
brown
blue
black
```
