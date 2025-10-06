#!/usr/bin/env -S awk -f
# Remove all except 00 and the specified countries from db.txt.
# Specify countries by doing '-v KEEP=FR,DE' or similar.
# Also strip comments for clarity, since this is a processing step
# and  sometimes the comments will refer to deleted countries.

BEGIN {
	keep_set["00"] = 1
	n = split(KEEP, a, ",")
	for (i = 1; i <= n; i++) keep_set[a[i]] = 1
}

/[ \t]*#/ {
	next
}

/^[^\t]*:/ {
	if (match($0, /^country[[:space:]]+([A-Z0-9][A-Z0-9]):/, m)) {
		keep = m[1] in keep_set
	} else {
		keep = 1
	}
}

{
	if (keep) print
}
