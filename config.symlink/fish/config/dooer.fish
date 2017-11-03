alias run="env DOOER_PUBLIC_FACADE_HOST=http://public-facade.service.internal yarn start"
alias run-prod="env NODE_ENV=production DOOER_PRIVATE_DOMAIN="" DOOER_SENTRY_ENDPOINT="" DOOER_ENVIRONMENT_NAME=production DOOER_PUBLIC_FACADE_HOST=https://api.d-e003.com yarn start"
alias run-on-dev="env DOOER_PUBLIC_FACADE_HOST=https://api.d-e003.com yarn start"
alias run-on-stage="env DOOER_PUBLIC_FACADE_HOST=https://api.s-e009.com PORT=7000 yarn start"
alias run-on-live="env DOOER_PUBLIC_FACADE_HOST=https://api.dooer.com PORT=7000 yarn start"
function devlog
  cowboy ssh c03 -E d-e003 -- nomad logs -job -f -tail -n 1000 $argv service | pretty-print-log
end
abbr ee="yarn services enable"
abbr ed="yarn services disable"
function er
  yarn services disable $argv; yarn services enable $argv
end