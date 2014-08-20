part of alpha.core;

typedef void Action();
typedef void Acceptor<T>(T input);
typedef T Producer<T>();
typedef void BiAcceptor<A, B>(A left, B right);
typedef T Transformer<I, T>(I input);
