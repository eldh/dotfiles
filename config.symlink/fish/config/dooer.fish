alias run="env DOOER_PUBLIC_FACADE_HOST=http://public-facade.service.internal yarn start"
alias run-prod="env NODE_ENV=production DOOER_PRIVATE_DOMAIN="" DOOER_SENTRY_ENDPOINT="" DOOER_ENVIRONMENT_NAME=production DOOER_PUBLIC_FACADE_HOST=https://api.d-e003.com yarn start"
alias run-on-dev="env DOOER_PUBLIC_FACADE_HOST=https://api.d-e003.com yarn start"
function devlog
  cowboy ssh c03 -E d-e003 -- nomad logs -job -f -tail -n 1000 $1 service | pretty-print-log
end
