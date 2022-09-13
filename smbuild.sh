wget https://kaino.kotus.fi/sanat/nykysuomi/kotus-sanalista-v1.tar.gz -O kotus-sanalista-v1.tar.gz
tar -xf kotus-sanalista-v1.tar.gz
rm kotus-sanalista-v1.tar.gz
git clone https://github.com/cdown/clipnotify.git
cd clipnotify
sudo make
sudo dnf install -y xsel
chmod +x clipnotify
chmod +x sm.sh
