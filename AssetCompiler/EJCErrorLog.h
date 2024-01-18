#define EJC_LOG_IF_NSERROR(error, message, ...) do { \
    if(error) { \
        NSLog(@"%@: %@", __VA_OPT__([NSString stringWithFormat: ) message \
        __VA_OPT__(,) __VA_ARGS__ __VA_OPT__(]), error); \
        error = nil; \
    } \
} while(0)