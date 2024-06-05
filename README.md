Symbolic Lab Language © 2024 by Emerald Cloud Laboratory Inc. is licensed under GNU GPL v3 

# SymbolicLabLanguage

The Symbolic Lab Language is developed by Emerald Cloud Lab for interacting with cloud laboratories through a Mathematica Notebook. 

## Getting Started

### Cloning the repository

You should clone the repository to a location on your Mathematica `$Path` (a good location for this is your home directory, `~` or `%userprofile%`). From a terminal:

```sh
cd ~
git clone git@github.com:emeraldsci/SymbolicLabLanguage.git
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


