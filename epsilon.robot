*** Settings ***
Library           String
Library           Selenium2Library
Library           Collections
Library           ums_service.py

*** Variables ***
${locator.edit.description}    css = div.table > tr : nth-child(4) > td
${locator.title}    css = div.table > tr : nth-child(3) > td
${locator.description}    css = div.table > tr : nth-child(4) > td
${locator.minimalStep.amount}    css = div.table > tr : nth-child(17) > td
${locator.value.amount}    css = div.table > tr : nth-child(11) > td
${locator.value.valueAddedTaxIncluded}    id=cbPosition_value_valueAddedTaxIncluded
${locator.value.currency}    id=tslPosition_value_currency
${locator.auctionPeriod.startDate}    css = div.table > tr : nth-child(24) > td
${locator.enquiryPeriod.startDate}    css = div.table > tr : nth-child(20) > td
${locator.enquiryPeriod.endDate}    css = div.table > tr : nth-child(21) > td
${locator.tenderPeriod.startDate}    css = div.table > tr : nth-child(22) > td
${locator.tenderPeriod.endDate}    css = div.table > tr : nth-child(23) > td
${locator.tenderId}    css = div.table > tr : nth-child(6) > td
${locator.procuringEntity.name}    css = div.table > tr : nth-child(10) > td
${locator.dgf}    номер фгв
${locator.dgfDecisionID}    id=ід рішення виконавчої ради
${locator.dgfDecisionDate}    id=від
${locator.eligibilityCriteria}    id=критерії оцінки
${locator.tenderAttempts}    id=tPosition_tenderAttempts
${locator.procurementMethodType}    id=tPosition_procurementMethodType
${locator.items[0].quantity}    id=tew_item_0_quantity
${locator.items[0].description}    id=tew_item_0_description
${locator.items[0].unit.code}    id=tw_item_0_unit_code
${locator.items[0].unit.name}    id=tslw_item_0_unit_code
${locator.items[0].deliveryAddress.postalCode}    id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.countryName}    id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.region}    id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.locality}    id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.streetAddress}    id=tw_item_0_Address_short
${locator.items[0].deliveryDate.endDate}    id=tdtpw_item_0_deliveryDate_endDate_Date
${locator.items[0].classification.scheme}    id=tw_item_0_classification_scheme
${locator.items[0].classification.id}    id=tew_item_0_classification_id
${locator.items[0].classification.description}    id=tw_item_0_classification_description
${locator.items[0].additionalClassifications[0].scheme}    id=tw_item_0_additionalClassifications_description
${locator.items[0].additionalClassifications[0].id}    id=tew_item_0_additionalClassifications_id
${locator.items[0].additionalClassifications[0].description}    id=tw_item_0_additionalClassifications_description
${locator.items[1].description}    id=tew_item_1_description
${locator.items[1].classification.id}    id=tew_item_1_classification_id
${locator.items[1].classification.description}    id=tw_item_1_classification_description
${locator.items[1].classification.scheme}    id=tw_item_1_classification_scheme
${locator.items[1].unit.code}    id=tw_item_1_unit_code
${locator.items[1].unit.name}    id=tslw_item_1_unit_code
${locator.items[1].quantity}    id=tew_item_1_quantity
${locator.items[2].description}    id=tew_item_2_description
${locator.items[2].classification.id}    id=tew_item_2_classification_id
${locator.items[2].classification.description}    id=tw_item_2_classification_description
${locator.items[2].classification.scheme}    id=tw_item_2_classification_scheme
${locator.items[2].unit.code}    id=tw_item_2_unit_code
${locator.items[2].unit.name}    id=tslw_item_2_unit_code
${locator.items[2].quantity}    id=tew_item_2_quantity
${locator.questions[0].title}    css=.qa_title
${locator.questions[0].description}    css=.qa_description
${locator.questions[0].date}    css=.qa_question_date
${locator.questions[0].answer}    css=.qa_answer
${locator.cancellations[0].status}    css=.cancel_status
${locator.cancellations[0].reason}    css=.cancel_reason
${locator.contracts.status}    css=.contract_status

*** Keywords ***
Підготувати клієнт для користувача
    [Arguments]    @{ARGUMENTS}
    Open Browser    ${USERS.users['${ARGUMENTS[0]}'].homepage}    ${USERS.users['${ARGUMENTS[0]}'].browser}    alias=${ARGUMENTS[0]}
    Set Window Size    @{USERS.users['${ARGUMENTS[0]}'].size}
    Set Window Position    @{USERS.users['${ARGUMENTS[0]}'].position}
    Run Keyword If    '${ARGUMENTS[0]}' != 'ums_Viewer'    Login    ${ARGUMENTS[0]}

Підготувати дані для оголошення тендера
    [Arguments]    ${username}    ${tender_data}    ${role_name}
    [Return]    ${tender_data}

Підготувати дані для оголошення тендера користувачем
    [Arguments]    ${username}    ${tender_data}    ${role_name}
    ${tender_data}=    adapt_test_mode    ${tender_data}
    [Return]    ${tender_data}

Login
    [Arguments]    @{ARGUMENTS}
    Input text    id=login-form-login    ${USERS.users['${ARGUMENTS[0]}'].login}
    Input text    id = login-form-password    ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Element    id=login-btn
    Sleep    2

Змінити користувача
    [Arguments]    @{ARGUMENTS}
    Go to    ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Sleep    2
    Input text    id=login-form-login    ${USERS.users['${ARGUMENTS[0]}'].login}
    Input text    id = login-form-password    ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Element    id=login-btn
    Sleep    2

Створити тендер
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tender_data
    ...    ${ARGUMENTS[2]} == ${filepath}
    Set Global Variable    ${TENDER_INIT_DATA_LIST}    ${ARGUMENTS[1]}
    ${title}=    Get From Dictionary    ${ARGUMENTS[1].data}    title
    ${dgf}=    Get From Dictionary    ${ARGUMENTS[1].data}    dgfID
    ${dgfDecisionDate}=    convert_ISO_DMY    ${ARGUMENTS[1].data.dgfDecisionDate}
    ${dgfDecisionID}=    Get From Dictionary    ${ARGUMENTS[1].data}    dgfDecisionID
    ${tenderAttempts}=    get_tenderAttempts    ${ARGUMENTS[1].data}
    ${description}=    Get From Dictionary    ${ARGUMENTS[1].data}    description
    ${procuringEntity_name}=    Get From Dictionary    ${ARGUMENTS[1].data.procuringEntity}    name
    ${items}=    Get From Dictionary    ${ARGUMENTS[1].data}    items
    ${budget}=    get_budget    ${ARGUMENTS[1]}
    ${step_rate}=    get_step_rate    ${ARGUMENTS[1]}
    ${currency}=    Get From Dictionary    ${ARGUMENTS[1].data.value}    currency
    ${valueAddedTaxIncluded}=    Get From Dictionary    ${ARGUMENTS[1].data.value}    valueAddedTaxIncluded
    ${start_day_auction}=    get_tender_dates    ${ARGUMENTS[1]}    StartDate
    ${start_time_auction}=    get_tender_dates    ${ARGUMENTS[1]}    StartTime
    ${item0}=    Get From List    ${items}    0
    ${descr_lot}=    Get From Dictionary    ${item0}    description
    ${unit}=    Get From Dictionary    ${items[0].unit}    code
    ${cav_id}=    Get From Dictionary    ${items[0].classification}    id
    ${quantity}=    get_quantity    ${items[0]}
    Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element    id=create-auction-btn    20
    Click Element    id=create-auction-btn
    Wait Until Page Contains Element    id=lots-name    20
    Select From List By Value    id=lots-procurementmethodtype    ${ARGUMENTS[1].data.procurementMethodType}
    Input text    id=lots-name    ${title}
    Input text    id=lots-description    ${description}
    Input text    id=lots-num    ${dgf}
    Input text    id=lots-dgfdecisionid    ${dgfDecisionID}
    Input text    id=lots-dgfdecisiondate    ${dgfDecisionDate}
    Select From List By Value    id=lots-tenderattempts    ${tenderAttempts}
    Input text    id=lots-start_price    ${budget}
    Click Element    id=lots-nds
    Input text    id=lots-auction_date    ${start_day_auction}
    input text    id=lots-step    ${step_rate}
    ${items}=    Get From Dictionary    ${ARGUMENTS[1].data}    items
    ${Items_length}=    Get Length    ${items}
    Додати предмет    ${items[${index}]}    ${index}
    Click Element    id=submit-auction-btn
    Sleep    3
    Select From List By Value    id = files-type    1
    Choose File    css = div.file-caption-name    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = publish-btn    20
    Click Element    id = publish-btn
    Wait Until Page Contains    Аукціон створено    10
    ${tender_id}=    Get Text    id = auction-id
    ${TENDER}=    Get Text    id= auction-id
    log to console    ${TENDER}
    [Return]    ${TENDER}

Додати предмет
    [Arguments]    ${item}    ${index}
    Input text    id=items-0-description    ${item.description}
    Input text    id=items-0-quantity    ${item.quantity}
    Select From List By Value    id=items-0-unit_code    ${item.unit.code}
    Select From List By Value    id=select2-items-0-classification_id-container    ${item.classification.id}
    Input text    id=items-address_postalcode    ${item.deliveryAddress.postalCode}
    Input text    id=items-address_region    ${item.deliveryAddress.region}
    Input text    id=items-address_locality    ${item.deliveryAddress.locality}
    Input text    id=items-address_streetaddress    ${item.deliveryAddress.streetAddress}

Завантажити документ
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == ${filepath}
    ...    ${ARGUMENTS[2]} == ${TENDER}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    8
    Choose File    css = div.file-caption-name    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Пошук тендера по ідентифікатору
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == ${TENDER}
    Switch Browser    ${ARGUMENTS[0]}
    Go to    ${USERS.users['${ARGUMENTS[0]}'].default_page}
    Wait Until Page Contains Element    name = Auctions[tenderID]
    Input Text    name = Auctions[tenderID]    ${ARGUMENTS[1]}
    Sleep    2
    Wait Until Page Contains Element    id=view-btn
    Click Element    id=view-btn
    sleep    2

Перейти до сторінки запитань
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = tenderUaId
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Click Element    id = question-btn
    Wait Until Page Contains Element    id= create-question-btn
    Click Element    id = create-question-btn
    Wait Until Page Contains Element    id=questions-title

Перейти до сторінки відмін
    Wait Until Page Contains Element    id=decline-btn
    Click Element    id=decline-btn
    Wait Until Page Contains Element    id=decline-id

Задати питання
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderUaId
    ...    ${ARGUMENTS[2]} == questionId
    ${title}=    Get From Dictionary    ${ARGUMENTS[2].data}    title
    ${description}=    Get From Dictionary    ${ARGUMENTS[2].data}    description
    Wait Until Page Contains Element    id= create-question-btn
    Click Element    id=create-question-btn
    Sleep    3
    Input text    id=questions-title    ${title}
    Input text    id=questions-description    ${description}
    Click Element    id= create-question-btn
    Sleep    3

Отримати інформацію про cancellations[0].status
    Перейти до сторінки відмін
    Wait Until Page Contains Element    css=#wl > tbody > tr:nth-child(5) > td
    ${return_value}=    Get text    css=#wl > tbody > tr:nth-child(5) > td
    [Return]    ${return_value}

Отримати інформацію про cancellations[0].reason
    Перейти до сторінки відмін
    Wait Until Page Contains Element    id = modal-btn
    Click Element    id = modal-btn
    ${return_value}=    Get text    id = messages-notes
    [Return]    ${return_value}

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = ${TENDER_UAID}
    Switch Browser    ${ARGUMENTS[0]}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Отримати інформацію із предмету
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tender_uaid
    ...    ${ARGUMENTS[2]} == item_id
    ...    ${ARGUMENTS[3]} == field_name
    ${return_value}=    Run Keyword And Return    ums.Отримати інформацію із тендера    ${username}    ${tender_uaid}    ${field_name}
    [Return]    ${return_value}

Отримати інформацію із тендера
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[2]} == fieldname
    ${return_value}=    Ryn Keyword    Отримати інформацію про ${ARGUMENTS[2]}
    [Return]    ${return_value}

Отримати текст із поля і показати на сторінці
    [Arguments]    ${fieldname}
    ${return_value}=    Get Text    ${locator.${fieldname}}
    [Return]    ${return_value}

Отримати інформацію про title
    ${return_value}=    Отримати текст із поля і показати на сторінці    title
    [Return]    ${return_value}

Отримати інформацію про procurementMethodType
    ${return_value}=    Отримати текст із поля і показати на сторінці    procurementMethodType
    [Return]    ${return_value}

Отримати інформацію про dgfID
    ${return_value}=    Отримати текст із поля і показати на сторінці    dgf
    [Return]    ${return_value}

Отримати інформацію про dgfDecisionID
    ${return_value}=    Отримати текст із поля і показати на сторінці    dgfDecisionID
    [Return]    ${return_value}

Отримати інформацію про dgfDecisionDate
    ${date_value}=    Отримати текст із поля і показати на сторінці    dgfDecisionDate
    ${return_value}=    ums_service.convert_date    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про tenderAttempts
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderAttempts
    ${return_value}=    Convert To Integer    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про eligibilityCriteria
    ${return_value}=    Отримати текст із поля і показати на сторінці    eligibilityCriteria

Отримати інформацію про status
    Reload Page
    Wait Until Page Contains Element    xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Sleep    2
    ${return_value}=    Get Text    id=tPosition_status
    [Return]    ${return_value}

Отримати інформацію про description
    ${return_value}=    Отримати текст із поля і показати на сторінці    description
    [Return]    ${return_value}

Отримати інформацію про value.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    value.amount
    ${return_value}=    Convert To Number    ${return_value.replace(' ', '').replace(',', '.')}
    [Return]    ${return_value}

Отримати інформацію про minimalStep.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    minimalStep.amount
    ${return_value}=    convert to number    ${return_value.replace(' ', '').replace(',', '.')}
    [Return]    ${return_value}

Внести зміни в тендер
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = ${TENDER_UAID}
    ...    ${ARGUMENTS[2]} == fieldname
    ...    ${ARGUMENTS[3]} == fieldvalue
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Click Element    id = update-btn
    Input Text    ${locator.edit.${ARGUMENTS[2]}}    ${ARGUMENTS[3]}
    Click Element    id=submit-auction-btn
    Wait Until Page Contains    Успішно оновлено    5
    ${result_field}=    Get Value    ${locator.edit.${ARGUMENTS[2]}}
    Should Be Equal    ${result_field}    ${ARGUMENTS[3]}

Отримати інформацію про items[${index}].quantity
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].quantity
    ${return_value}=    Convert To Number    ${return_value.replace(' ', '').replace(',', '.')}
    [Return]    ${return_value}

Отримати інформацію про items[${index}].unit.code
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].unit.code
    [Return]    ${return_value}

Отримати інформацію про items[${index}].unit.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].unit.name
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].description
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.id
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].classification.id
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.scheme
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].classification.scheme
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].classification.description
    [Return]    ${return_value}

Отримати інформацію про value.currency
    ${return_value}=    Get Selected List Value    slPosition_value_currency
    [Return]    ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
    ${return_value}=    is_checked    cbPosition_value_valueAddedTaxIncluded
    [Return]    ${return_value}

Отримати інформацію про auctionID
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderId
    [Return]    ${return_value}

Отримати інформацію про procuringEntity.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    procuringEntity.name
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.latitude
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.longitude
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про auctionPeriod.startDate
    ${date_value}=    Get Text    css = div.table > tr : nth-child(5) > td
    ${return_value}=    convert_date_to_iso    ${date_value}    ${time_value}
    [Return]    ${return_value}

Отримати інформацію про auctionPeriod.endDate
    ${date_value}=    Get Text    css = div.table > tr : nth-child(5) > td
    ${return_value}=    convert_date_to_iso    ${date_value}    ${time_value}

Отримати інформацію про tenderPeriod.startDate
    ${date_value}=    Get Text    css = div.table > tr : nth-child(5) > td
    ${return_value}=    convert_date_to_iso    ${date_value}    ${time_value}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${date_value}=    Get Text    css = div.table > tr : nth-child(5) > td
    ${return_value}=    convert_date_to_iso    ${date_value}    ${time_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
    ${date_value}=    Get Text    css = div.table > tr : nth-child(5) > td
    ${return_value}=    convert_date_to_iso    ${date_value}    ${time_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${date_value}=    Get Text    css = div.table > tr : nth-child(5) > td
    ${return_value}=    convert_date_to_iso    ${date_value}    ${time_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.countryName
    [Return]    ${return_value.split(', ')[0]}

Отримати інформацію про items[0].deliveryAddress.postalCode
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.postalCode
    [Return]    ${return_value.split(', ')[1]}

Отримати інформацію про items[0].deliveryAddress.region
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.region
    [Return]    ${return_value.split(', ')[2]}

Отримати інформацію про items[0].deliveryAddress.locality
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.locality
    [Return]    ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.streetAddress
    [Return]    ${return_value.split(', ')[4]}

Отримати інформацію про items[0].deliveryDate.endDate
    ${date_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryDate.endDate
    ${return_value}=    ums_service.convert_date    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].title
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'rec_qa_title')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'rec_qa_title')])[${index}]
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].description
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'rec_qa_description')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'rec_qa_description')])[${index}]
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].answer
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'rec_qa_answer')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'rec_qa_answer')])[${index}]
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].date
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'rec_qa_date')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'rec_qa_date')])[${index}]
    ${return_value}=    convert_date_time_to_iso    ${return_value}
    [Return]    ${return_value}

Відповісти на питання
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = ${TENDER_UAID}
    ...    ${ARGUMENTS[2]} = 0
    ...    ${ARGUMENTS[3]} = answer_data
    ${answer}=    Get From Dictionary    ${ARGUMENTS[3].data}    answer
    Перейти до сторінки запитань
    Wait Until Page Contains Element    xpath=(//*[contains(@class, 'bt_addAnswer') and not(contains(@style,'display: none'))])
    Click Element    css=.bt_addAnswer:first-child
    Input Text    id=e_answer    ${answer}
    Click Element    id=SendAnswer
    sleep    1

Подати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ${amount}=    get_str    ${ARGUMENTS[2].data.value.amount}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    id = view-btn
    Click Element    id= view-btn
    sleep    3s
    Click Element    id = create-bid-btn
    sleep     5s
    Input Text    id=bids-value_amount    ${amount}
    Choose File    css = div.file-caption-name    ${ARGUMENTS[3]}
    Click Element    id=
    sleep    3
    ${resp}=    Get Value    id=bids-value_amount
    [Return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    xpath=(//*[@id='btnShowBid' and not(contains(@style,'display: none'))])
    Click Element    id=btnShowBid
    Sleep    3
    Wait Until Page Contains Element    xpath=(//*[@id='btn_delete' and not(contains(@style,'display: none'))])
    Click Element    id=btn_delete

Отримати інформацію із пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${field}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    sleep    3s
    Click Element    id= view-btn
    Sleep    3s
    Click Element    id = create-bid-btn
    Sleep    3s
    ${value}=    Get Value    id=bids-value_amount
    ${value}=    Convert To Number    ${value}
    [Return]    ${value}

Змінити цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ${amount}=    get_str    ${ARGUMENTS[2].data.value.amount}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    id= view-btn
    Click Element    id= view-btn
    sleep    3s
    Click Element    id = create-bid-btn
    sleep     5s
    Input Text    id=bids-value_amount    ${amount}
    Choose File    css = div.file-caption-name    ${ARGUMENTS[3]}
    Click Element    id= create-bid-btn

Завантажити фінансову ліцензію
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ${amount}=    get_str    ${ARGUMENTS[2].data.value.amount}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    id = view-btn
    Click Element    id= view-btn
    sleep    3s
    Click Element    id = create-bid-btn
    sleep     5s
    Input Text    id=bids-value_amount    ${amount}
    Choose File    css = div.file-caption-name    ${ARGUMENTS[3]}
    Click Element    id = create-bid-btn

Отримати інформацію про bids
    [Arguments]    @{ARGUMENTS}
    Викликати для учасника    ${ARGUMENTS[0]}    Оновити сторінку з тендером    ${ARGUMENTS[1]}
    Click Element    id=bids_ref

Отримати посилання на аукціон для глядача
    [Arguments]    @{ARGUMENTS}
    Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element    xpath=(//*[@id='aPosition_auctionUrl' and not(contains(@style,'display: none'))])
    Sleep    5
    ${result} =    Get Text    id=aPosition_auctionUrl
    [Return]    ${result}

Отримати посилання на аукціон для учасника
    [Arguments]    @{ARGUMENTS}
    Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element    xpath=(//*[@id='aPosition_auctionUrl' and not(contains(@style,'display: none'))])
    Sleep    5
    ${result}=    Get Text    id=aPosition_auctionUrl
    [Return]    ${result}

Завантажити документ в тендер з типом
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${doc_type}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    ${doc_type}
    Choose File    css = div.file-caption-name    ${filepath}
    Sleep    2
    Click Element    id=upload_button

Завантажити ілюстрацію
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    6
    Choose File    css = div.file-caption-name    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Додати Virtual Data Room
    [Arguments]    ${username}    ${tender_uaid}    ${vdr_url}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    10
    Choose File    css = div.file-caption-name    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Додати публічний паспорт активу
    [Arguments]    ${username}    ${tender_uaid}    ${vdr_url}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ums.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    2
    Choose File    css = div.file-caption-name    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Отримати інформацію із документа по індексу
    [Arguments]    ${username}    ${tender_uaid}    ${document_index}    ${field}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${doc_value}=    Get Text    id = doc_id
    [Return]    ${doc_value}

Отримати інформацію із документа
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}    ${field_name}
    ${doc_value}=    Get Text    id = doc_id
    [Return]    ${doc_value}

Відповісти на запитання
    [Arguments]    ${username}    ${tender_uaid}    ${answer_data}    ${item_id}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Перейти до сторінки запитань
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'btAnswer') and contains(@class, '${item_id}')])
    Click Element    xpath=(//span[contains(@class, 'btAnswer') and contains(@class, '${item_id}')])
    Input Text    id=e_answer    ${answer_data.data.answer}
    Click Element    id=SendAnswer
    sleep    1

Отримати інформацію із запитання
    [Arguments]    ${username}    ${tender_uaid}    ${question_id}    ${field_name}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Перейти до сторінки запитань
    ${return_value}=    Run Keyword If    '${field_name}' == 'title'    Get Text    xpath=(//span[contains(@class, 'qa_title') and contains(@class, '${item_id}')])
    ...    ELSE IF    '${field_name}' == 'answer'    Get Text    xpath=(//span[contains(@class, 'qa_answer') and contains(@class, '${item_id}')])
    ...    ELSE    Get Text    xpath=(//span[contains(@class, 'qa_description') and contains(@class, '${item_id}')])
    [Return]    ${return_value}

Задати запитання на тендер
    [Arguments]    ${username}    ${tender_uaid}    ${question}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Задати питання    ${username}    ${tender_uaid}    ${question}

Додати предмет закупівлі
    [Arguments]    ${username}    ${tender_uaid}    ${item}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${index}=    ums.Отримати кількість предметів в тендері    ${username}    ${tender_uaid}
    ${ItemAddButtonVisible}=    Page Should Contain Element    id=btn_items_add
    Run Keyword If    '${ItemAddButtonVisible}'=='PASS'    Run Keywords    Додати предмет    ${item}    ${index}
    ...    AND    Click Element    id=btnPublic
    ...    AND    Wait Until Page Contains    Публікацію виконано    10

Видалити предмет закупівлі
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${ItemAddButtonVisible}=    Page Should Contain Element    id=btn_items_add
    Run Keyword If    '${ItemAddButtonVisible}'=='PASS'    Run Keywords    Wait Until Page Contains Element    xpath=(//ul[contains(@class, 'bt_item_delete') and contains(@class, ${item_id})])
    ...    AND    Click Element    xpath=(//ul[contains(@class, 'bt_item_delete') and contains(@class, ${item_id})])
    ...    AND    Click Element    id=btnPublic
    ...    AND    Wait Until Page Contains    Публікацію виконано    10

Отримати кількість документів в тендері
    [Arguments]    ${username}    ${tender_uaid}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${tender_doc_number}=    Get Matching Xpath Count    xpath=(//*[@id=' doc_id']/)
    [Return]    ${tender_doc_number}

Отримати документ
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Click Element    xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])
    sleep    3
    ${file_name}=    Get Text    xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])
    ${url}=    Get Element Attribute    xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])@href
    download_file    ${url}    ${file_name.split('/')[-1]}    ${OUTPUT_DIR}
    [Return]    ${file_name.split('/')[-1]}

Отримати дані із документу пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${bid_index}    ${document_index}    ${field}
    ${document_index}=    inc    ${document_index}
    ${result}=    Get Text    xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table[${document_index}]//span[contains(@class, 'documentType')])
    [Return]    ${result}

Отримати кількість документів в ставці
    [Arguments]    ${username}    ${tender_uaid}    ${bid_index}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${bid_doc_number}=    Get Matching Xpath Count    xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table)
    [Return]    ${bid_doc_number}

Скасування рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${tender_uaid}    ${award_num}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Cancel_button')])
    Sleep    1
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Cancel_button')])

Дискваліфікувати постачальника
    [Arguments]    ${username}    ${tender_uaid}    ${award_num}    ${description}
    Input text    xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Reject_description')])    ${description}
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Reject_button')])

Завантажити документ рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${filepath}    ${tender_uaid}    ${award_num}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//div[contains(@class, 'award_docs')]//span[contains(@class, 'add_document')])
    Choose File    xpath=(//*[@id='upload_form']/input[2])    ${filepath}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Завантажити протокол аукціону
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${award_index}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    xpath=(//*[@id='btnShowBid' and not(contains(@style,'display: none'))])
    Click Element    id=btnShowBid
    Sleep    1
    Wait Until Page Contains Element    xpath=(//*[@id='btn_documents_add' and not(contains(@style,'display: none'))])
    Click Element    id=btn_documents_add
    Select From List By Value    id=slFile_documentType    auctionProtocol
    Choose File    xpath=(//*[@id='upload_form']/input[2])    ${filepath}
    Sleep    2
    Click Element    id=upload_button

Завантажити угоду до тендера
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}    ${filepath}
    ums.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//div[contains(@class, 'contract_docs')]//span[contains(@class, 'add_document')])
    Select From List By Value    id=slFile_documentType    contractSigned
    Choose File    xpath=(//*[@id='upload_form']/input[2])    ${filepath}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Підтвердити підписання контракту
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}
    ${file_path}    ${file_title}    ${file_content}=    create_fake_doc
    Sleep    5
    ums.Завантажити угоду до тендера    ${username}    ${tender_uaid}    1    ${filepath}
    Wait Until Page Contains Element    xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//span[contains(@class, 'contract_register')])
