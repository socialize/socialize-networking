.SUFFIXES:

.PHONY: subst clean-subst

SUBST_BUILD_FILES := SZNetworking/SZNetworkingVersion.h

%: %.in version
	sed \
		-e "s^@project_version\@^$(PROJECT_VERSION)^g" \
		< $< > $@ || rm $@

subst: $(SUBST_BUILD_FILES)

clean-subst:
	rm -f $(SUBST_BUILD_FILES)
