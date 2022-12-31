
import Foundation

public func openImage(image path: String) throws -> UnsafePointer<mach_header>? {
    if #available(macOS 11.0, iOS 14.0, *) {
        if _dyld_shared_cache_contains_path(path) {
            print("[i] ellekit: image is in the shared cache")
            
            return nil
        }
    }
    
    dlopen(path, RTLD_LAZY)
    
    let index = (0..<_dyld_image_count())
        .filter {
            String(cString: _dyld_get_image_name($0))
                .contains(path)
        }
        .first ?? 1
    
    
    return _dyld_get_image_header(index)
}
