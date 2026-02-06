default: verify
.PHONY: verify signature verify-online

verify:
	for b in `git ls-files | sed -n 's/\.html$$//p'`; do \
		echo "$$b.html"; \
		git diff --exit-code "$$b.sig.txt" "$$b.html" && \
		gpg --verify "$$b.sig.txt" "$$b.html" || exit 1 \
	; done

signature:
	for html in *.html; do \
		sig=`basename "$$html" .html`.sig.txt; \
		gpg --verify "$$sig" "$$html" 2>/dev/null ||\
		gpg -v -ba -o "$$sig" "$$html" \
	; done

DOMAIN=zunda.ninja
verify-online:
	for b in `git ls-files | sed -n 's/\.html$$//p'`; do \
		echo "$$b.html"; \
		curl -so verify-online.html https://$(DOMAIN)/$$b.html && \
		curl -so verify-online.sig.txt https://$(DOMAIN)/$$b.sig.txt && \
		gpg --verify verify-online.sig.txt verify-online.html; \
		rm -f verify-online.html verify-online.sig.txt \
	; done
