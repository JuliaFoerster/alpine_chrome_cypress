
Cypress.on('uncaught:exception', (err, runnable) => {
  return false
})

describe('portfolio query add field from library', () => {

  it('attempts to log in user', () => {
    cy.visit('www.google.com')

    cy.contains('Google')
  })

})
