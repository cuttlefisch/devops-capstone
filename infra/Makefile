GREEN := "\033[0;32m"
NC := "\033[0;0m"

LOG := @sh -c '\
	   printf ${GREEN}; \
	   echo -e "\n> $$1\n"; \
	   printf ${NC}' VALUE

checkov:
	$(LOG) "Running checkov"
	@docker run --rm -it -v $$PWD/$${TARGET}:/data bridgecrew/checkov --directory /data
