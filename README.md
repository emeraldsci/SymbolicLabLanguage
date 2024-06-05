Symbolic Lab Language © 2024 by Emerald Cloud Laboratory Inc. is licensed under GNU GPL v3 

# SymbolicLabLanguage

The Symbolic Lab Language is developed by Emerald Cloud Lab for interacting with cloud laboratories through a Mathematica Notebook. 

## Getting Started

### Cloning the repository

You should clone the repository to a location on your Mathematica `$Path` (a good location for this is your home directory, `~` or `%userprofile%`). From a terminal:

```sh
cd ~
git clone git@github.com:emeraldsci/SLL.git
```

If you're cloning using a tool like GitHub Desktop
([like so](https://github.com/emeraldsci/ecl/blob/develop/docs/github-desktop/cloning.md)), there's a prompt for initializing [Git LFS](https://git-lfs.github.com/).  But on the console, to get access to our large binary `*.nb` documentation notebooks, you can otherwise do this:

```sh
cd SLL
git lfs install
```


### Updating Trusted Directories

In order for our documentation notebooks to work correctly, the repository much be in on of the Mathematica "Trusted Directories". The easiest way to do this is to update this setting to include the location of the newly cloned repository.

1. Navigate to the Mathematica preferences through the File menu.
2. Select the "Security" tab.
3. Click "Edit Trusted Directories..."
4. Click the "Add" button.
5. Enter the following in the input field and click OK.
    ```Mathematica
    FrontEnd`FileName[{$HomeDirectory,"SLL"}]
    ```
6. When asked "Are you sure" hit OK.

### Loading Packages

You can use `Get[]` to load all the SLL packages quickly in the notebook as follows:

```Mathematica
<<SLL`
```

For further information regarding packaging and loading specific packages, see the [Packager Documentation](Packager/README.md)

### Logging In

To perform any operations against the database, you must be logged in. To do so, use the `Login[]` function after loading SLL with your username/password.

```Mathematica
In[1]:= <<SLL`
In[2]:= Login["example@emeraldcloudlab.com"] (* will prompt for password *)
Out[2]= True
In[3]:= Download[Object[Data,Example,"aXRlGnZmwp4m"]]
Out[3]= <|ID->Object[Data,Example,aXRlGnZmwp4m],Type->Object[Data,Example],Name->"My Favourite Object"|>
```

### Using the Test Database

By default the SLL packages point to the production instance of the Constellation database service. To use the test database you must point to a different web service endpoint. Use the `Database` parameter to `Login[]` to change the database.

```Mathematica
In[2]:= <<SLL`
In[3]:= Login["example@emeraldcloudlab.com", Database -> Stage]
Out[3]= True
```

## Deploying to Production

We deploy pre-built versions of SLL for use in all our applications (Command Center, Nexus, Engine). We automatically build the latest commit of every push to the `master` branch and of every pull request. A build for a given commit should take approximately 10 minutes after which the distro will be available for use by all the apps. In order to run tests against a branch, you must open a pull request so that the distros will be built for your branch. The apps will download the latest successfully built distro on the master branch and load SLL from that distro.

While a commit is being built, the status of that commit in the GitHub UI will go to "pending" (yellow circle). Once the build is complete, the status of the commit will change either to success (green checkmark) or failure (red X). Once the commit status is green, it is available for use by all the apps. At this time we don't have a good way to expose the nature of the failures so if you have an issue with a commit being built you can ping a member of Engineering to look into it for you.

### App Updating

#### Nexus

Nexus loads the ``SLL`Dev` `` distro (which contains all the internal packages) and will update itself on user Login.

#### Engine

Engine loads the ``SLL`Dev` `` distro (which contains all the internal packages) and will update itself on user Login and when entering a procedure (if necessary).

#### Command Center

Command Center loads the ``SLL` `` distro (which **does not** contain any internal packages) and will update itself on user Login.

## How SLL Loads

When you Load SLL in Mathematica as below, you are loading the file at `Kernel/init.m`:

```Mathematica
In[1] := <<SLL`
```

This does 3 things:

1. Adds the repository folder to the Mathematica paclet search path via `PacletDirectoryAdd`.
2. We then load the ``Packager` `` package which is formatted as a normal Mathematica package and can be loaded via `Needs[]` once the directory is on the paclet search path (which is why step 1 is necessary).
3. We call `LoadDistro["./distros/SLL.json"]` which loads only the packages specified in the SLL distro (those which are shipped to customers in the Command Center).

### Dev

Loading the dev distro is almost the same as loading SLL except a separate list of packages is loaded:

```Mathematica
In[1] := <<SLL`Dev`
```

The above loads the file `Dev.m` which does the same thing as loading the SLL distro except uses the configuration file at `./distros/Dev.json` which includes additional packages such as those used to run Engine (which are not shipped to customers in the command center).


