
----------------------------------
## quickshear/toolVersion ##
Quickshear uses a skull stripped version of an anatomical images as a reference to deface the unaltered anatomical image.

Example:
```
quickshear.py [-h] anat_file mask_file defaced_file [buffer]

```

More documentation can be found here: [link_to_documentation](https://github.com/nipy/quickshear)

To make the executables and scripts inside this container transparently available in the command line of environments where Neurocommand is installed: ml quickshear/toolVersion

Citation:
```
Schimke, Nakeisha, and John Hale. “Quickshear defacing for neuroimages.” Proceedings of the 2nd USENIX conference on Health security and privacy. USENIX Association, 2011.
```

License: BSD-3-Clause license

----------------------------------
