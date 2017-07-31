import Loadable from 'react-loadable'
import frontend, { authMiddleware } from '@dooer/frontend'
import { reducer as formReducer } from '@dooer/react-forms'

// // import '@dooer/fe-ui-kit/build/base.css'
import '@dooer/fe-data-table/lib/main.css'
import '@dooer/fe-icon-kit/lib/styles.css'

import LoginView from './views/login'
import IosGateMiddleware from '../../lib/ios-gate-middleware'

const app = frontend({
  reducers: { form: formReducer },
})

const loading = () => null

const OrganizationPicker = Loadable({
  loader: () => import(/* webpackChunkName: "orgpicker" */ './views/organization-picker'),
  loading,
})

app.use(IosGateMiddleware)
app.route(
  '/forgot-password',
  Loadable({
    loader: () => import(/* webpackChunkName: "forgotpassword" */ './views/forgot-password'),
    loading,
  })
)
app.route(
  '/magic-login/:emailToken/claim',
  Loadable({
    loader: () => import(/* webpackChunkName: "magiclink" */ './views/magic-link'),
    loading,
  })
)
app.route(
  '/invitations/:id',
  Loadable({
    loader: () => import(/* webpackChunkName: "claim-membership-invitation" */ './views/claim-membership-invitation'),
    loading,
  })
)
app.route(
  '/password-reset',
  Loadable({
    loader: () => import(/* webpackChunkName: "passwordreset" */ './views/claim-password-reset'),
    loading,
  })
)
app.route('/', authMiddleware(LoginView), OrganizationPicker)
app.route('/choose-company', authMiddleware(LoginView), OrganizationPicker)

export default app
