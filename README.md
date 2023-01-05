# Common Scripts

A curated list of the commonly used scripts in a daily basis

## How to make the file to be excuted

```
chmod u+x
```

### Delete all pods exclude a namespace

Delete all runnings pods exclude a namespace. Usually to be used for deleting all pods exclude kube-system Usage:

```
./delete_all_pods_exclude_system.sh -v <excluded-namespace>
```

```
./delete_all_pods_exclude_system.sh -v kube-system
```
