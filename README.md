MATLAB implementation of the differentially-private database fingerprinting scheme introduced in  "Differentially-Private Fingerprinting of Relational Databases." arXiv preprint arXiv:2109.02768 (2021).

The script main_dpfp.m generates an instance of a dp fingerprinted database, which is robust under 80\% random bit flipping attack.

The script main_dp_followedby_fp.m generates a fingerprinted database using the two-stage baseline, i.e., dp perturbation followed by fingerprinting.

Folder "functions" records the functions used in this work. In particular, DPFP.m implements the proposed scheme, and extract_fp.m extracts the fingerprint embedded by the the proposed scheme. insert_fingerprint.m and detect_fingerprint.m implement the scheme proposed in "Fingerprinting relational databases: Schemes and specialties" (IEEE TDSC 2005)