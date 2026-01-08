default: verify
.PHONY: verify signature

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
