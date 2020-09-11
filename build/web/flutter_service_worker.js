'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "5bf8acdb1e06defe98d392851829d3f9",
"assets/assets/fonts/Montserrat-Regular.ttf": "ee6539921d713482b8ccd4d0d23961bb",
"assets/assets/fonts/SourceSansPro-Regular.ttf": "c1678b46f7dd3f50ceac94ed4e0ad01a",
"assets/assets/images/logo/logo.png": "b16670812435a3d28450c96deb18c95d",
"assets/assets/images/logo/logoZoom.png": "d75c631e31d26d4cefdfa04b39e8cd43",
"assets/assets/images/NoImg.png": "22fa4d91b8a961823a8b2c9d2565a974",
"assets/assets/images/sex/female.png": "db2263e59eeaf4a6c25503d498e13ec3",
"assets/assets/images/sex/male.png": "cbf3a638a1a90891c844091fa25671ef",
"assets/assets/images/socialMedia/beru.png": "d75c631e31d26d4cefdfa04b39e8cd43",
"assets/assets/images/socialMedia/facebook.png": "abf5e01fa622d6fbe049de264c9c0882",
"assets/assets/images/socialMedia/google.png": "718d07e9977908379361326981a7d2d4",
"assets/FontManifest.json": "567eb83a2d48bfe124b8797efcbae42b",
"assets/fonts/MaterialIcons-Regular.otf": "a68d2a28c526b3b070aefca4bac93d25",
"assets/NOTICES": "bc33aa87e3eb372ae5dee81b14efcfb2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"iconData/android-icon-144x144.png": "82a5581e3046f5916fcbdb3f8384f063",
"iconData/android-icon-192x192.png": "e5b6aa6ef63165b8e65eaf0ce9b37425",
"iconData/android-icon-36x36.png": "c4c36eb5e9def55164a5bb4435a2a37c",
"iconData/android-icon-48x48.png": "b529775c65af62ee16c282cf5398a421",
"iconData/android-icon-72x72.png": "ca0f1920ce0a61b02d34c459397b6c0d",
"iconData/android-icon-96x96.png": "26d338f9e4b87f4876618ffa7198f263",
"iconData/apple-icon-114x114.png": "183eb7c7cf253b7a1d65d6238167c301",
"iconData/apple-icon-120x120.png": "9efdf9f86dcbf10eefbeab200f1cfb80",
"iconData/apple-icon-144x144.png": "82a5581e3046f5916fcbdb3f8384f063",
"iconData/apple-icon-152x152.png": "59940d5f3a09008006bf5c1ba0d7dba4",
"iconData/apple-icon-180x180.png": "52b810f2813f20d7fbddfe554c930d79",
"iconData/apple-icon-57x57.png": "8ba0f5d976fb11009fa87dcde06f1df3",
"iconData/apple-icon-60x60.png": "8bfce7a69e3f63f3428f7f2645b32341",
"iconData/apple-icon-72x72.png": "ca0f1920ce0a61b02d34c459397b6c0d",
"iconData/apple-icon-76x76.png": "a26808375a97a6c3c1c62dcd04894411",
"iconData/apple-icon-precomposed.png": "d9a4d99aced5f23970e17e02254bd556",
"iconData/apple-icon.png": "d9a4d99aced5f23970e17e02254bd556",
"iconData/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"iconData/favicon-16x16.png": "e1520b5dc0fee7214f14617cb5daf846",
"iconData/favicon-32x32.png": "1f8eb7380201e30e742cead2a764b797",
"iconData/favicon-96x96.png": "26d338f9e4b87f4876618ffa7198f263",
"iconData/favicon.ico": "ae49152866e7f86e2994c3b2da95b239",
"iconData/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"iconData/ms-icon-144x144.png": "82a5581e3046f5916fcbdb3f8384f063",
"iconData/ms-icon-150x150.png": "93b359eae5204033401d2dfbbb77d933",
"iconData/ms-icon-310x310.png": "d78101ffd88de0c7f155d314c74172f6",
"iconData/ms-icon-70x70.png": "23e2baa53711cf0a2a00c53d8db3838d",
"index.html": "5c5f671837a42b09ed432fe610da1211",
"/": "5c5f671837a42b09ed432fe610da1211",
"main.dart.js": "a54dc0d378ab75941028eae8ca914dc9",
"manifest.json": "190f03662e4e8d3791f22fa74e83eb30"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      // Provide a 'reload' param to ensure the latest version is downloaded.
      return cache.addAll(CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');

      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }

      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#')) {
    key = '/';
  }
  // If the URL is not the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache. Ensure the resources are not cached
        // by the browser for longer than the service worker expects.
        var modifiedRequest = new Request(event.request, {'cache': 'reload'});
        return response || fetch(modifiedRequest).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    return self.skipWaiting();
  }

  if (event.message === 'downloadOffline') {
    downloadOffline();
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
