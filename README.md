# Roku Aquarium Screensaver

A small Roku screensaver that plays an aquarium video full screen, muted and on loop. The video streams from a web server on your home network, such as a NAS or a Raspberry Pi.

I made it after Roku retired its built-in Aquatic Life screensaver on Dec 1, 2026. The repo has **no video** in it, so you bring your own footage. It isn't affiliated with Roku.

![icon](images/icon_fhd.png)

## 1. Get a video

Any H.264 MP4 works, and 1080p is a good size. These sites have free aquarium footage:

- [Pexels aquarium videos](https://www.pexels.com/search/videos/aquarium/)
- [Pixabay aquarium videos](https://pixabay.com/videos/search/aquarium/)

Use footage you have the rights to.

## 2. Host it on your network

Roku developer apps are limited to a few MB, so the video can't ship inside the app. The Roku streams it over HTTP from any local web server instead. Use plain `http://`, because Roku rejects self-signed HTTPS certificates.

**Synology example:** install **Web Station**, copy the file to the `web` share as `web/aquarium/aquarium.mp4`, and give the NAS a fixed IP. Your URL is `http://<nas-ip>/aquarium/aquarium.mp4`.

Keep the server off the internet. Don't port-forward 80 or 443, and consider a firewall rule that only allows your LAN subnet.

Open the URL in a browser to check that it plays.

## 3. Enable Roku Developer Mode

On the Roku remote press **Home ×3, Up ×2, Right, Left, Right, Left, Right**. Enable the installer, accept the agreement and set a dev password. Pick one you don't use anywhere else. Write down the Roku's IP address.

## 4. Build and install

Create `local.mk` (gitignored):

```make
VIDEO_URL = http://192.168.1.10/aquarium/aquarium.mp4
ROKU_IP = 192.168.1.20
```

Then:

```sh
make install ROKU_PASS='your-dev-password'
```

It prints `Install Success` when it works. To install from a browser instead, run `make zip`, open `http://<roku-ip>`, log in as `rokudev` and upload `out/aquarium.zip` with **Install with zip**.

## 5. Use it

Pick it under **Settings > Theme > Screensavers > Aquarium** and set the wait time. It also shows up as an app called **Aquarium** on the home screen.

## Notes

- The **Preview** button in Roku settings can close a sideloaded screensaver right away. It still starts normally when the Roku goes idle, and the home screen app works too.
- If the video server is off or unreachable, the screen stays black.
- On a Roku with a USB port, like the Roku Ultra, you can play the video from a USB stick. Set `VIDEO_URL = ext1:/aquarium.mp4`.
- A Roku holds one sideloaded app at a time. It stays through reboots, but sideloading another app or turning off Developer Mode removes it.
- My footage looked flat on the TV, so I brightened it and raised the saturation with ffmpeg:

  `ffmpeg -i in.mp4 -an -vf "eq=contrast=1.08:brightness=0.03:saturation=1.35:gamma=1.05" -c:v libx264 -crf 18 -movflags +faststart aquarium.mp4`

## License

MIT. I made the app icon with ChatGPT.
