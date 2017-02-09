*** Settings ***
Library           String
Library           Selenium2Library
Library           Collections
Library           epsilon_service.py

*** Variables ***
${locator.edit.description}    id = auction-description
${locator.title}    id = auction-title
${locator.description}    id = auction-description
${locator.minimalStep.amount}    id = auction-minimalStep_amount
${locator.value.amount}    id = auction_value_amount
${locator.value.valueAddedTaxIncluded}    id=auction-valueAddedTaxIncluded
${locator.value.currency}    id=value-currency
${locator.auctionPeriod.startDate}    id = auction-auctionPeriod_startDate
${locator.enquiryPeriod.startDate}    id = auction-enquiryPeriod_startDate
${locator.enquiryPeriod.endDate}    id = auction-enquiryPeriod_endDate
${locator.tenderPeriod.startDate}    id = auction-tenderPeriod_startDate
${locator.tenderPeriod.endDate}    id = auction-tenderPeriod_endDate
${locator.tenderId}    id = auction-auctionID
${locator.procuringEntity.name}    id = auction-procuringEntity_name
${locator.dgf}    id = auction-dgfID
${locator.dgfDecisionID}    id=auction-dgfDecisionID
${locator.dgfDecisionDate}    id=auction-dgfDecisionDate
${locator.eligibilityCriteria}    id=auction-eligibilityCriteria
${locator.tenderAttempts}    id=auction-tenderAttempts
${locator.procurementMethodType}    id=auction-procurementMethodType
${locator.items[0].quantity}    id=item-quantity-0
${locator.items[0].description}    id = item-description-0
${locator.items[0].unit.code}    id = item-unit_code0
${locator.items[0].unit.name}    id = item-unit_name0
${locator.items[0].deliveryAddress.postalCode}    id=item-postalCode0
${locator.items[0].deliveryAddress.region}    id=item-region0
${locator.items[0].deliveryAddress.locality}    id=item-locality0
${locator.items[0].deliveryAddress.streetAddress}    id=item-streetAddress0
${locator.items[0].classification.scheme}    id=item-classification-scheme0
${locator.items[0].classification.id}    id = item-classification_id0
${locator.items[0].classification.description}    id = item-classification_description0
${locator.items[0].additionalClassifications[0].scheme}    id=tw_item_0_additionalClassifications_description
${locator.items[0].additionalClassifications[0].id}    id=tew_item_0_additionalClassifications_id
${locator.items[0].additionalClassifications[0].description}    id=tw_item_0_additionalClassifications_description
${locator.items[1].description}    id = item-description-1
${locator.items[1].classification.id}    id = item-classification_id1
${locator.items[1].classification.description}    id = item-classification_description1
${locator.items[1].classification.scheme}    id=item-classification-scheme1
${locator.items[1].unit.code}    id = item-unit_code1
${locator.items[1].unit.name}    id=item-unit_name1
${locator.items[1].quantity}    id=item-quantity-1
${locator.items[2].description}    id = item-description-2
${locator.items[2].classification.id}    id = item-classification_id2
${locator.items[2].classification.description}    id = item-classification_description2
${locator.items[2].classification.scheme}    id=item-classification-scheme2
${locator.items[2].unit.code}    id = item-unit_code2
${locator.items[2].unit.name}    id = item-unit_name2
${locator.items[2].quantity}    id=item-quantity-2
${locator.questions[0].title}    id = question-title0
${locator.questions[0].description}    id=question-description0
${locator.questions[0].date}    id = question-date0
${locator.questions[0].answer}    id = question-answer0
${locator.cancellations[0].status}    id = status
${locator.cancellations[0].reason}    id = messages-notes
${locator.contracts.status}    css=.contract_status

*** Keywords ***
Підготувати клієнт для користувача
    [Arguments]    @{ARGUMENTS}
    Open Browser    ${USERS.users['${ARGUMENTS[0]}'].homepage}    ${USERS.users['${ARGUMENTS[0]}'].browser}    alias=${ARGUMENTS[0]}
    Set Window Size    @{USERS.users['${ARGUMENTS[0]}'].size}
    Set Window Position    @{USERS.users['${ARGUMENTS[0]}'].position}
    Run Keyword If    '${ARGUMENTS[0]}' != 'epsilon_Viewer'    Login    ${ARGUMENTS[0]}

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
    Input text    id=lots-step    ${step_rate}
    Input text    id = lots-bidding_date    ${locator.auctionPeriod.startDate}
    Input text    id = lots-bidding_date_end    ${locator.enquiryPeriod.endDate}
    Input text    id = lots-auction_date    ${locator.tenderPeriod.startDate}
    Input text    id = lots-auction_date_end    ${locator.tenderPeriod.endDate}
    Input text    id = lots-address
    Input text    id = lots-delivery_time
    Input text    id = lots-delivery_term
    Input text    id = lots-requires
    Input text    id = lots-notes
    Click Element    id=submit-auction-btn
    Wait Until Page Contains    Аукціон збережено як чернетку    10
    Select From List By Value    id = files-type    1
    Choose File    id = auction-file    ${ARGUMENTS[2]}
    Click Element    id = lot-document-upload-btn
    ${items}=    Get From Dictionary    ${ARGUMENTS[1].data}    items
    ${Items_length}=    Get Length    ${items}
    Додати предмет    ${items[${index}]}    ${index}
    Click Element    id = submissive-btn
    Wait Until Page Contains    Успішно оновлено    10
    Click Element    id =publish-btn
    Wait Until Page Contains    Аукціон створено
    ${tender_id}=    Get Text    id = auction-id
    ${TENDER}=    Get Text    id= auction-id
    log to console    ${TENDER}
    [Return]    ${TENDER}

Додати предмет
    [Arguments]    ${item}    ${index}
    Click Element    id = create-item-btn
    Input text    id=items-description    ${item.description}
    Input text    id=items-quantity    ${item.quantity}
    Select From List By Value    id=items-unit_code    ${item.unit.code}
    Select From List By Value    id=select2-items-classification_id-container    ${item.classification.id}
    Input text    id=items-address_postalcode    ${item.deliveryAddress.postalCode}
    Input text    id=items-address_region    ${item.deliveryAddress.region}
    Input text    id=items-address_locality    ${item.deliveryAddress.locality}
    Input text    id=items-address_streetaddress    ${item.deliveryAddress.streetAddress}
    Click Element    id = submit-item-btn

Завантажити документ
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == ${filepath}
    ...    ${ARGUMENTS[2]} == ${TENDER}
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    8
    Choose File    id = auction-file    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=lot-document-upload-btn
    Reload Page

Пошук тендера по ідентифікатору
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == ${TENDER}
    Switch Browser    ${ARGUMENTS[0]}
    Go to    ${USERS.users['${ARGUMENTS[0]}'].default_page}
    Wait Until Page Contains Element    name = Auctions[auctionID]
    Input Text    name = Auctions[auctionID]    ${ARGUMENTS[1]}
    Sleep    4
    Click Element    name = Auctions[title]
    Sleep    2
    Wait Until Page Contains Element    id=auction-view-btn
    Click Element    id=auction-view-btn
    Sleep    10

Перейти до сторінки запитань
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = tenderUaId
    Click Element    id = tab-selector-2
    Wait Until Page Contains Element    id= create-question-btn

Перейти до сторінки відмін
    Go To    https://proumstrade.com.ua/cancelations/index
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
    Wait Until Page Contains Element    id = auction-view-btn
    Click Element    id = auction-view-btn
    Click Element    id = tab-2
    Wait Until Page Contains Element    id= create-question-btn
    Click Element    id=create-question-btn
    Sleep    3
    Input text    id=question-title    ${title}
    Input text    id=question-description    ${description}
    Click Element    id= create-question-btn

Отримати інформацію про cancellations[0].status
    Перейти до сторінки відмін
    Wait Until Page Contains Element    id = status
    ${return_value}=    Get text    id = status
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
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Отримати інформацію із предмету
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tender_uaid
    ...    ${ARGUMENTS[2]} == item_id
    ...    ${ARGUMENTS[3]} == field_name
    ${return_value}=    Run Keyword And Return    epsilon.Отримати інформацію із тендера    ${username}    ${tender_uaid}    ${field_name}
    [Return]    ${return_value}

Отримати інформацію із тендера
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[2]} == fieldname
    ${return_value}=    Run Keyword    Отримати інформацію про ${ARGUMENTS[2]}
    [Return]    ${return_value}

Отримати текст із поля і показати на сторінці
    [Arguments]    ${fieldname}
    Sleep    3
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
    ${return_value}=    epsilon_service.convert_date    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про tenderAttempts
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderAttempts
    ${return_value}=    Convert To Integer    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про eligibilityCriteria
    ${return_value}=    Отримати текст із поля і показати на сторінці    eligibilityCriteria

Отримати інформацію про status
    Reload Page
    Wait Until Page Contains Element    id = auction-status
    Sleep    2
    ${return_value}=    Get Text    id = auction-status
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
    Click Element    id=submissive-btn
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
    ${return_value}=    Get Text    id = value-currency
    [Return]    ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
    ${return_value}=    is_checked    auction-valueAddedTaxIncluded
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
    ${date_value}=    Get Text    auction-auctionPeriod_startDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про auctionPeriod.endDate
    ${date_value}=    Get Text    auction-auctionPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${date_value}

Отримати інформацію про tenderPeriod.startDate
    ${date_value}=    Get Text    auction-tenderPeriod_startDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${date_value}=    Get Text    auction-tenderPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
    ${date_value}=    Get Text    auction-enquiryPeriod_startDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${date_value}=    Get Text    auction-enquiryPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${date_value}
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
    ${return_value}=    epsilon_service.convert_date    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].title
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'question-title')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'question-title')])[${index}]
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].description
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'question-description')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'question-description')])[${index}]
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].answer
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'question-answer')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'question-answer')])[${index}]
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].date
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    xpath=(//span[contains(@class, 'anwser-date')])[${index}]
    ${return_value}=    Get text    xpath=(//span[contains(@class, 'anwser-date')])[${index}]
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
    Click Element    id = create-answer-btn
    Sleep    3
    Input Text    id=question-answer    ${answer}
    Click Element    id=create-question-btn

Подати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ${amount}=    get_str    ${ARGUMENTS[2].data.value.amount}
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    id = view-btn
    Click Element    id= view-btn
    sleep    3s
    Click Element    id = create-bid-btn
    sleep    5s
    Input Text    id=bids-value_amount    ${amount}
    Choose File    id = upload-file-input
    Click Element    id= create-bid-btn
    sleep    3
    ${resp}=    Get Value    id=bids-value_amount
    [Return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    Go To    http://proumstrade.com.ua/bids/index
    Wait Until Page Contains Element    id = view-bids-btn
    Click Element    id = view-bids-btn
    Sleep    3
    Wait Until Page Contains Element    id = modal-btn
    Click Element    id=modal-btn
    Wait Until Page Contains Element    id = messages-notes
    Input Text    id = messages-notes    Some reason
    Click Element    id = decline-modal-id

Отримати інформацію із пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${field}
    Go To    http://proumstrade.com.ua/bids/index    ${tender_uaid}
    Wait Until Page Contains Element    id = view-btn
    Click Element    id = view-btn
    Wait Until Page Contains Element    id=bids-value-amount
    ${value}=    Get Value    id=bids-value_amount
    ${value}=    Convert To Number    ${value}
    [Return]    ${value}

Змінити цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == ${test_bid_data}
    ${amount}=    get_str    ${ARGUMENTS[0].data.value.amount}
    Go To    https://proumstrade.com.ua/bids/index
    Wait Until Page Contains Element    id= update-bids-btn
    Click Element    id= update-bids-btn
    sleep    3s
    Input Text    id=bids-value_amount    ${amount}
    Click Element    id= update-bid-btn

Завантажити фінансову ліцензію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${test_bid_data}
    ...    ${ARGUMENTS[3]} == ${filepath}
    ${amount}=    get_str    ${ARGUMENTS[2].data.value.amount}
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id= update-btn
    sleep    3s
    Click Element    id = create-bid-btn
    sleep    5s
    Choose File    css = div.file-caption-name    ${ARGUMENTS[3]}
    Click Element    id = create-bid-btn

Отримати посилання на аукціон для глядача
    [Arguments]    @{ARGUMENTS}
    Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element    id = auction-url
    Sleep    5
    ${result} =    Get Text    id = auction-url
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
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    ${doc_type}
    Choose File    css = div.file-caption-name    ${filepath}
    Sleep    2
    Click Element    id=upload_button

Завантажити ілюстрацію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == \ ${filepath}
    ...    ${ARGUMENTS[2]} == ${tender_uaid}
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    6
    Choose File    id = auction-file    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Додати Virtual Data Room
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${vdr_url}
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    10
    Choose File    id = auction-file    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Додати публічний паспорт активу
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    ...    ${ARGUMENTS[2]} == ${vdr_url}
    epsilon.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Wait Until Page Contains Element    id = update-btn
    Click Element    id=update-btn
    Select From List By Value    id = files-type    2
    Choose File    id = auction-file    ${ARGUMENTS[1]}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Отримати інформацію із документа по індексу
    [Arguments]    ${username}    ${tender_uaid}    ${document_index}    ${field}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${doc_value}=    Get Text    xpath=(//*[@id='auction-documents']/table[${document_index + 1}]//span[contains(@class, 'documentType')])
    [Return]    ${doc_value}

Отримати інформацію із документа
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}    ${field_name}
    ${doc_value}=    Get Text    id = document-id
    [Return]    ${doc_value}

Відповісти на запитання
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = ${TENDER_UAID}
    ...    ${ARGUMENTS[2]} = 0
    ...    ${ARGUMENTS[3]} = answer_data
    ${answer}=    Get From Dictionary    ${ARGUMENTS[3].data}    answer
    Перейти до сторінки запитань
    Click Element    id = create-answer-btn
    Sleep    3
    Input Text    id=question-answer    ${answer}
    Click Element    id=create-question-btn
    sleep    1

Отримати інформацію із запитання
    [Arguments]    ${username}    ${tender_uaid}    ${question_id}    ${field_name}
    Перейти до сторінки запитань
    Sleep    2
    ${return_value}=    Run Keyword If    '${field_name}' == 'title'    Get Text    xpath=(//span[contains(@class, 'question-title') and contains(@class, '${item_id}')])
    ...    ELSE IF    '${field_name}' == 'answer'    Get Text    xpath=(//span[contains(@class, 'question-answer') and contains(@class, '${item_id}')])
    ...    ELSE    Get Text    xpath=(//span[contains(@class, 'question-description') and contains(@class, '${item_id}')])
    [Return]    ${return_value}

Задати запитання на тендер
    [Arguments]    ${username}    ${tender_uaid}    ${question}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Задати питання    ${username}    ${tender_uaid}    ${question}

Отримати кількість документів в тендері
    [Arguments]    ${username}    ${tender_uaid}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${tender_doc_number}=    Get Matching Xpath Count    (//*[@id='auction-documents']/table)
    [Return]    ${tender_doc_number}

Отримати документ
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    sleep    3
    ${file_name}=    Get Text    id = document-id
    ${url}=    Get Element Attribute    id = document-id@href
    download_file    ${url}    ${file_name.split('/')[-1]}    ${OUTPUT_DIR}
    [Return]    ${file_name.split('/')[-1]}

Отримати дані із документу пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${bid_index}    ${document_index}    ${field}
    ${document_index}=    inc    ${document_index}
    ${result}=    Get Text    id = document-id
    [Return]    ${result}

Скасування рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${tender_uaid}    ${award_num}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Cancel_button')])
    Sleep    1
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//*[contains(@class, 'Cancel_button')])

Завантажити документ рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${filepath}    ${tender_uaid}    ${award_num}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//div[contains(@class, 'award_docs')]//span[contains(@class, 'add_document')])
    Choose File    xpath=(//*[@id='upload_form']/input[2])    ${filepath}
    Sleep    2
    Click Element    id=upload_button
    Reload Page

Завантажити протокол аукціону
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${award_index}
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
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
    epsilon.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
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
    epsilon.Завантажити угоду до тендера    ${username}    ${tender_uaid}    1    ${filepath}
    Wait Until Page Contains Element    xpath=(//*[@id='tPosition_status' and not(contains(@style,'display: none'))])
    Click Element    xpath=(//*[@id='pnAwardList']/div[last()]//span[contains(@class, 'contract_register')])
