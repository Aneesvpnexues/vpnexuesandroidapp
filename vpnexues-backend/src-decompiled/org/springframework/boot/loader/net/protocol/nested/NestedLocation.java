/*
 * Decompiled with CFR 0.152.
 */
package org.springframework.boot.loader.net.protocol.nested;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.nio.file.Path;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.boot.loader.net.util.UrlDecoder;

public record NestedLocation(Path path, String nestedEntryName) {
    private static final Map<String, NestedLocation> cache = new ConcurrentHashMap<String, NestedLocation>();

    public NestedLocation(Path path, String nestedEntryName) {
        if (path == null) {
            throw new IllegalArgumentException("'path' must not be null");
        }
        this.path = path;
        this.nestedEntryName = nestedEntryName != null && !nestedEntryName.isEmpty() ? nestedEntryName : null;
    }

    public static NestedLocation fromUrl(URL url) {
        if (url == null || !"nested".equalsIgnoreCase(url.getProtocol())) {
            throw new IllegalArgumentException("'url' must not be null and must use 'nested' protocol");
        }
        return NestedLocation.parse(UrlDecoder.decode(url.toString().substring(7)));
    }

    public static NestedLocation fromUri(URI uri) {
        if (uri == null || !"nested".equalsIgnoreCase(uri.getScheme())) {
            throw new IllegalArgumentException("'uri' must not be null and must use 'nested' scheme");
        }
        return NestedLocation.parse(uri.getSchemeSpecificPart());
    }

    static NestedLocation parse(String path) {
        if (path == null || path.isEmpty()) {
            throw new IllegalArgumentException("'path' must not be empty");
        }
        int index = path.lastIndexOf("/!");
        return cache.computeIfAbsent(path, l -> NestedLocation.create(index, l));
    }

    private static NestedLocation create(int index, String location) {
        String locationPath;
        String string = locationPath = index != -1 ? location.substring(0, index) : location;
        if (NestedLocation.isWindows() && !NestedLocation.isUncPath(location)) {
            while (locationPath.startsWith("/")) {
                locationPath = locationPath.substring(1, locationPath.length());
            }
        }
        String nestedEntryName = index != -1 ? location.substring(index + 2) : null;
        return new NestedLocation(!locationPath.isEmpty() ? Path.of(locationPath, new String[0]) : null, nestedEntryName);
    }

    private static boolean isWindows() {
        return File.separatorChar == '\\';
    }

    private static boolean isUncPath(String input) {
        return !input.contains(":");
    }

    static void clearCache() {
        cache.clear();
    }
}

