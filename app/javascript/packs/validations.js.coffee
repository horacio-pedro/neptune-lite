class window.Validation

  @UserSettingForm = ->
    $('#sub_user_form').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      ignore: 'input[type=hidden]'
      rules:
        user_name: required: true, alphabet: true
        email: required: true
        role_id: required: true
        password: required: true
        password_confirmation:
          required: true
        avatar: accept: 'jpg,jpeg,png'

      messages:
        user_name: required: 'O nome não pode ficar em branco', alphabet: "Apenas letras, números e sublinhados são permitidos"
        email:  required: 'O e-mail não pode ficar em branco'
        role_id: required: 'A função não pode ficar em branco'
        password: required: 'A Palavra-passe não pode ficar em branco'
        password_confirmation: required: 'A confirmação da palavra-passe não pode ficar em branco'
        avatar: accept: 'Carregue a imagem apenas neste formato (jpg, jpeg, png).'

      errorPlacement: ($error, $element) ->
        if ($element.attr('name') == 'avatar')
          $('.file-field').append $error
        else
          $element.parent().closest('.input-field').append($error)

      $('.file-path').on 'change', ->
        $('#user_avatar').valid()


  @CompanySettingForm = ->
    jQuery.validator.addMethod 'alphabet', ((value, element) ->
      @optional(element) || /[a-zA-Z\u00C0-\u00ff\w -]$/i.test(value);
    ), 'Apenas letras, números e sublinhados são permitidos'

    $('#companyForm').submit ->
      $('.invalid-error').removeClass('hidden')
    $('.invalid-error').removeClass('hidden')
    $('#companyForm').validate
      onfocusout: (element) ->
        if !($("label[for='" + $(element).attr('id') + "']").hasClass('active'))
          $(element).valid()
        else
          $('#'+element.id+'-error').addClass('hidden')
      onkeyup: (element) ->
        $('#'+element.id+'-error').removeClass('hidden')
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'

      rules:
        'company[company_name]': required: true, alphabet: true
        'company[contact_name]': required: true, alphabet: true
        'company[email]': required: true
        'company[logo]': accept: 'jpg,jpeg,png'
      messages:
        'company[company_name]': required: 'O nome da empresa não pode ficar em branco'
        'company[contact_name]': required: 'O nome do contato não pode ficar em branco'
        'company[email]': required: 'Email não pode ficar em branco'
        'company[logo]': accept: 'Carregue a imagem apenas neste formato (jpg, jpeg, png).'

      errorPlacement: ($error, $element) ->
        if ($element.attr('name') == 'company[logo]')
          $('.file-field').append $error
        else
          $element.parent().closest('.input-field').append($error)

      $('.file-path').on 'change', ->
        $('#company_logo').valid()



  @RoleSettingForm = ->
    $('#new_role').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      rules:
        'role[name]': required: true, alphabet: true
      messages:
        'role[name]': required: 'O nome não pode ficar em branco', alphabet: "Apenas letras, números e sublinhados são permitidos"


  @InvoiceForm = ->
    $('.invoice-client-select').on 'focusout', (e) ->
      $('#invoice_client_id').valid()

    $('#s2id_invoice_invoice_line_items_attributes_0_item_id').on 'focusout', (e) ->
      $('#invoice_invoice_line_items_attributes_0_item_id').valid()

    jQuery.validator.addMethod 'lessThan', ((value, element) ->
          return value <= $('#invoice_due_date_picker').val()
      ), 'A data da fatura não pode ser posterior à data de vencimento'

    jQuery.validator.addMethod 'greaterThan', ((value, element) ->
          return value >= $('#invoice_date_picker').val()
      ), 'A data de vencimento não pode ser inferior à data da fatura'

    $('.invoice-form').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      ignore: 'input[type=hidden]'
      rules:
        'invoice[client_id]': required: true
        'invoice[recurring_schedule_attributes][delivery_option]': required: '#recurring:checked'
        'invoice[invoice_date]': lessThan: true
        'invoice[due_date]': greaterThan: true
        'invoice[invoice_line_items_attributes][0][item_id]': required: true
      messages:
        'invoice[client_id]': required: 'Client cannot be blank'
        'invoice[invoice_line_items_attributes][0][item_id]': required: 'O item não pode ficar em branco'
        'invoice[recurring_schedule_attributes][delivery_option]': required: 'Selecione pelo menos uma opção de entrega'

      errorPlacement: ($error, $element) ->
        if ($element.attr('name') == 'invoice[client_id]')
          $('#s2id_invoice_client_id').append $error
        else if ($element.attr('name') == 'invoice[recurring_schedule_attributes][delivery_option]')
          $('.invoice_recurring_schedule_delivery_option').append $error
        else
          $error.insertAfter($element);

      jQuery.validator.addClassRules
        cost: min: 0
      jQuery.validator.addClassRules
        qtyy: min: 0

      jQuery.validator.messages.min = "O valor não deve ser inferior a 0"



  @EstimateForm = ->
    $('.estimate-select-client').on 'focusout', (e) ->
      $('#estimate_client_id').valid()

    $('#s2id_estimate_estimate_line_items_attributes_0_item_id').on 'focusout', (e) ->
      $('#estimate_estimate_line_items_attributes_0_item_id').valid()

    $('.estimate-form').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      ignore: 'input[type=hidden]'
      rules:
        'estimate[client_id]': required: true
        'estimate[estimate_line_items_attributes][0][item_id]': required: true
      messages:
        'estimate[client_id]': required: 'O client não pode ficar em branco'
        'estimate[estimate_line_items_attributes][0][item_id]': required: 'O item não pode ficar em branco'



  @ItemForm = ->
    jQuery.validator.addMethod 'currencyscents', ((value, element) ->
      @optional(element) or /^\d{0,7}(\.\d{0,2})?$/i.test(value)
    ), 'Apenas duas casas decimais são permitidas'

    jQuery.validator.addMethod 'alphabet', ((value, element) ->
      @optional(element) || /[a-zA-Z\u00C0-\u00ff\w -]$/i.test(value);
    ), 'Apenas letras, números e sublinhados são permitidos'

    $('.item_form').submit ->
        $('.invalid-error').removeClass('hidden')
      $('.invalid-error').removeClass('hidden')
    $('.item_form').validate
      onfocusin: (element) ->
        $(element).valid()
      onfocusout: (element) ->
        if !($("label[for='" + $(element).attr('id') + "']").hasClass('active'))
          $(element).valid()
        else
          $('#'+element.id+'-error').addClass('hidden')
      onkeyup: (element) ->
        $('#'+element.id+'-error').removeClass('hidden')
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      rules:
        'item[item_description]': required: true, alphabet: true
        'item[unit_cost]': required: true, number: true, currencyscents: true
        'item[quantity]': required: true, number: true, currencyscents: true
        'item[item_name]': required: true, alphabet: true, remote: {url: "/items/verify_item_name", type: "get", dataType: 'json', data: {
          'item_id': ->
            $('.item_id').html()
          'item_name': ->
            $('#item_item_name').val()
          'newItem': ->
            if ($('.item_form').hasClass('edit_item'))
              'edit_item'
        }
        }

      messages:
        'item[item_name]': required: 'O nome não pode ficar em branco', remote: 'Item com o mesmo nome já existe'
        'item[item_description]': required: 'Description cannot be blank'
        'item[unit_cost]': required: 'O custo unitário não pode ficar em branco', number: 'O custo unitário deve ser numérico'
        'item[quantity]': required: 'A quantidade não pode ficar em branco', number: 'A quantidade deve ser numérica'



  @TaxForm = ->
    jQuery.validator.addMethod 'currencyscents', ((value, element) ->
      @optional(element) or /^\d{0,7}(\.\d{0,2})?$/i.test(value)
    ), 'Apenas duas casas decimais são permitidas'

    jQuery.validator.addMethod 'alphabet', ((value, element) ->
      @optional(element) || /[a-zA-Z\u00C0-\u00ff\w -]$/i.test(value);
      ), 'Apenas letras, números e sublinhados são permitidos'

    $('.tax_form').submit ->
      $('.invalid-error').removeClass('hidden')
    $('.invalid-error').removeClass('hidden')
    $('.tax_form').validate
      onfocusout: (element) ->
        if !($("label[for='" + $(element).attr('id') + "']").hasClass('active'))
          $(element).valid()
        else
          $('#'+element.id+'-error').addClass('hidden')
      onkeyup: (element) ->
        $('#'+element.id+'-error').removeClass('hidden')
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      rules:
        'tax[percentage]': required: true, number: true, max: 100, currencyscents: true
        'tax[name]': required: true, alphabet: true, remote: {url: "/taxes/verify_tax_name", type: "get", dataType: 'json', data: {
          'tax_id': ->
            $('.tax_id').html()
          'tax_name': ->
            $('#tax_name').val()
          'newTax': ->
            if ($('.tax_form').hasClass('edit_tax'))
              'edit_tax'
        }
        }
      messages:
        'tax[percentage]': required: 'A porcentagem não pode ficar em branco', number: 'A porcentagem deve ser numérica', max: 'A porcentagem do imposto não pode exceder 100%'
        'tax[name]': required: 'O nome não pode ficar em branco', remote: 'Imposto com o mesmo nome já existe'



  @ClientForm = ->
    $('#newClient').submit ->
      $('.invalid-error').removeClass('hidden')
    $('.invalid-error').removeClass('hidden')

    jQuery.validator.addMethod 'emailRegex', ((value, element) ->
      return this.optional( element ) || /^.+@.+\..+$/.test( value );
    ), 'Por favor insira um endereço de e-mail válido'

    $('#newClient').validate
      onfocusin: (element) ->
        $(element).valid()
      onfocusout: (element) ->
        if !($("label[for='" + $(element).attr('id') + "']").hasClass('active'))
          $(element).valid()
        else
          $('#'+element.id+'-error').addClass('hidden')
      onkeyup: (element) ->
        $('#'+element.id+'-error').removeClass('hidden')
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      ignore: 'input[type=hidden]'
      rules:
        'client[organization_name]': required: true, alphabet: true
        'client[first_name]': required: true, alphabet: true
        'client[last_name]': required: true, alphabet: true
        'client[role_id]': required: true
        'client[email]': required: true, emailRegex: true, remote: {url: "/clients/verify_email", type: "get", dataType: 'json', data: {
          'client_id': ->
            $('.client_id').html()
          'email': ->
            $('#client_email').val()
          'newClient': ->
            if ($('#newClient').hasClass('edit_client'))
              'edit_client'
        }
        }
      messages:
        'client[organization_name]': required: 'O nome da organização não pode ficar em branco', alphabet: "Apenas letras, números e sublinhados são permitidos"
        'client[first_name]': required: 'O primeiro nome não pode ficar em branco', alphabet: "Apenas letras, números e sublinhados são permitidos"
        'client[last_name]': required: 'O sobrenome não pode ficar em branco', alphabet: "Apenas letras, números e sublinhados são permitidos"
        'client[role_id]': required: 'A função não pode ficar em branco'
        'client[email]': required: 'Email não pode ficar em branco', remote: "E-mail já existe"



  @PaymentForm = ->
    jQuery.validator.addMethod 'lessThanOrEqualToDueAmount', ((value, element) ->
      return value <= parseFloat($(element).closest('.small_field').find('span').html())
    ), 'O valor não deve ser maior do que o valor restante'

    $('#payments_form').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      submitHandler: (form) ->
        valid = true
        jQuery('[id^=payments_payment_amount_]').each (e) ->
          if !$('#' + $(this).attr('id').split('-error')[0]).valid()
            valid = false
            return false
        if valid
         form.submit

      rules:
        'payments[][payment_amount]': required: true, number: true, min: 1, lessThanOrEqualToDueAmount: '.paid_full:checked'
      messages:
        'payments[][payment_amount]': required: 'A quantidade não pode ficar em branco', number: 'Por favor, insira um valor válido',
        min: 'O valor deve ser maior que 0'

      $('.payment_right').each ->
        parent = $(this)
        $(this).find('.paid_full').on 'change', ->
          parent.find('.payment_amount').valid()

    $('#new_payment').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      rules:
        'payment[payment_amount]': required: true, number: true, min: 1, lessThanOrEqualToDueAmount: '.paid_full:checked'
      messages:
        'payment[payment_amount]': required: 'A quantidade não pode ficar em branco', number: 'Por favor, insira um valor válido',
        min: 'O valor deve ser maior que 0'

      $('#payment_paid_full').on 'change', ->
        $('#payment_payment_amount').valid()

  @recurringFrequencyForm = ->
    $('.recurring_frequency_form').validate
      onfocusout: (element) ->
        $(element).valid()
      onkeyup: (element) ->
        $(element).valid()
      errorClass: 'error invalid-error'
      errorElement: 'span'
      rules:
        'recurring_frequency[title]': required: true
        'recurring_frequency[number_of_days]': required: true, number: true, min: 0
      messages:
        'recurring_frequency[title]': required: 'Título é obrigatório'
        'recurring_frequency[number_of_days]': required: 'Número de dias são necessários', number: 'Por favor, insira apenas números', min: 'Número de dias não pode ser negativo'
