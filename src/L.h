#define L(X) NSLocalizedString(X, nil)
#define LF(X, ...) [NSString stringWithFormat:L(X), __VA_ARGS__]
#define LU(X) [NSURL URLWithString:L(X)]
