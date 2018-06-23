ssh: AWS_IP=$(shell \
	terraform output public-ip)
ssh:
	ssh -i ./keys/key.rsa ubuntu@$(AWS_IP)
