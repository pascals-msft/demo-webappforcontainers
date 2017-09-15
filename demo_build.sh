# not to be run as a script
exit

# build container image:
docker build -t demo-flask .

# run container:
CONTAINER_ID=$(docker run -d -p 5000:5000 demo-flask)
docker ps -a

# test the app:
curl localhost:5000
curl localhost:5000/json

# cleanup: stop and remove the container
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID
#docker rmi demo-flask

# publish the image to Docker Hub
docker tag demo-flask pascals/demo-flask
docker push pascals/demo-flask
