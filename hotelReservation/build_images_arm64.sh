sudo docker buildx build \
  --platform linux/arm64 \
  --build-arg SERVICE=attractions \
  -f Dockerfile.arm64 \
  -t migvasc/hotel-attractions:arm64 \
  --push \
  .

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=frontend \
-f Dockerfile.arm64 \
-t migvasc/hotel-frontend:arm64 \
--push \
.


sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=profile \
-f Dockerfile.arm64 \
-t migvasc/hotel-profile:arm64 \
--push \
.

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=rate \
-f Dockerfile.arm64 \
-t migvasc/hotel-rate:arm64 \
--push \
.

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=recommendation \
-f Dockerfile.arm64 \
-t migvasc/hotel-recommendation:arm64 \
--push \
.

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=reservation \
-f Dockerfile.arm64 \
-t migvasc/hotel-reservation:arm64 \
--push \
.

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=review \
-f Dockerfile.arm64 \
-t migvasc/hotel-review:arm64 \
--push \
.

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=search \
-f Dockerfile.arm64 \
-t migvasc/hotel-search:arm64 \
--push \
.

sudo docker buildx build \
--platform linux/arm64 \
--build-arg SERVICE=user \
-f Dockerfile.arm64 \
-t migvasc/hotel-user:arm64 \
--push \
.
