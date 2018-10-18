# Openshift Origin Testing notes

Tests assume that there's an existing cluster and KUBECONFIG is set
to the appropiate configuration file.

## General 

TODO

## Extended

**Build the tests**

```
make build-extended-test
```

**Run all the tests**

```
TEST_ONLY=1 test/extended/conformance.sh 2>&1 | tee conformance.log
```

###Focus on specific tests

This is a bit tricky you have to se the FOCUS environment variable which internally
sets the --ginkgo.focus for the test suite.
Since this is managed by a shell script and the tests description include square brackets
this have to be scaped on the command line:

```
FOCUS='\[Feature:Router\]' TEST_ONLY=1 test/extended/conformance.sh 2>&1 | tee conformance.log
```

This will run all the tests that have [Feature:Router] in their description:

```
[WARNING] REMINDER, EXTENDED TESTS NO LONGER START A CLUSTER.
[WARNING] THE CLUSTER REFERENCED BY THE 'KUBECONFIG' ENV VAR IS USED.

[INFO] Running tests against existing cluster...
[INFO] Running parallel tests N=<default> with focus \[Feature:Router\]
I1018 12:52:43.126218   72259 test.go:85] Extended test version v4.0.0-alpha.0+2ee9761-306-dirty
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router converges when multiple routers ar ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router converges when multiple routers ar ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should expose a health check on th ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should expose prometheus metrics f ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should expose the profiling endpoi ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should override the route host for ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should override the route host wit ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should respond with 503 to unrecog ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should run even if it has no acces ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should serve a route that points t ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should serve routes that were crea ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should serve the correct routes wh ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should serve the correct routes wh ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should set Forwarded headers appro ... (0s)
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should support reencrypt to servic ... (0s)
Running Suite: Extended
=======================
Random Seed: 1539885168 - Will randomize all specs
Will run 1264 specs

Running in parallel across 5 nodes
```

If you want to run a specific test you can include the full name of the test:

```
FOCUS='should respond with 503 to unrecognized hosts' TEST_ONLY=1 test/extended/conformance.sh 2>&1 | tee conformance.log
```

This will run only the test with the specific text:

```

[WARNING] REMINDER, EXTENDED TESTS NO LONGER START A CLUSTER.
[WARNING] THE CLUSTER REFERENCED BY THE 'KUBECONFIG' ENV VAR IS USED.

[INFO] Running tests against existing cluster...
[INFO] Running parallel tests N=<default> with focus should respond with 503 to unrecognized hosts
I1018 12:40:22.969972   69296 test.go:85] Extended test version v4.0.0-alpha.0+2ee9761-306-dirty
    ok       [Conformance][Area:Networking][Feature:Router] The HAProxy router should respond with 503 to unrecog ... (0s)
Running Suite: Extended
=======================
Random Seed: 1539884428 - Will randomize all specs
Will run 1264 specs

Running in parallel across 5 nodes

```
