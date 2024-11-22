touch ~/terraform-log.log
echo $(date) >> ~/terraform-log.log
cat ~/terraform-log.log

echo ""
echo "Updating Debian APT"
sudo apt update && sudo apt upgrade -y

echo ""
echo "Helm Version"
helm version

echo ""
echo "Kubectl Version"
kubectl version

echo ""
echo "docker version"
sudo docker version

echo ""
echo "Gcloud Info"
gcloud info

echo ""
echo "Connecting to Kubernetes"
SDV_CLUSTER_NAME="sdv-cluster"
SDV_PROJECT_REGION="europe-west1"
gcloud container clusters get-credentials $SDV_CLUSTER_NAME --region $SDV_PROJECT_REGION

echo ""
echo "List $SDV_CLUSTER_NAME nodes"
kubectl get nodes

echo ""
echo "Adding the current user to the docker group"
echo "sudo usermod -aG docker $USER"
sudo usermod -aG docker $USER

echo ""
echo "Docker configurations"
gcloud auth configure-docker europe-west1-docker.pkg.dev --quiet
cat ~/.docker/config.json

echo ""
echo "Test the pull command with the current user."
docker pull europe-west1-docker.pkg.dev/sdva-2108202401/horizon-sdv-dev/aaos_builder:latest

echo ""
echo "Removing old project"
rm -rf ~/acn-horizon-sdv

echo ""
echo "Cloning github acn-horizon-sdv project"
git clone https://x-access-token:${GITHUB_ACCESS_TOKEN}@github.com/AGBG-ASG/acn-horizon-sdv.git ~/acn-horizon-sdv

echo ""
echo "List current branch and remote"
cd ~/acn-horizon-sdv
git branch -vva

